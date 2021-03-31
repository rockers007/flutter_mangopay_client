import 'dart:convert';

import 'models/models.dart';
import 'utils/utils.dart';

enum MangopayEnvironment {
  SandBox,
  Production,
}

class MangopayClient {
  String clientID;
  String clientPassword;
  String baseURL;
  String version;
  MangopayEnvironment environment;

  static MangopayClient _instance;

  MangopayClient._({
    this.clientID = '',
    this.clientPassword = '',
    String url,
    this.environment = MangopayEnvironment.SandBox,
    this.version = 'v2.01',
  }) {
    url ??= _getApiUrl(environment);
    this.baseURL = url;
  }

  static String _getApiUrl(MangopayEnvironment environment) {
    switch (environment) {
      case MangopayEnvironment.SandBox:
        return MANGOPAY_SANDBOX_URL;
      case MangopayEnvironment.Production:
        return MANGOPAY_PRODUCTION_URL;
    }
    throw Exception('Unknown Environment type: $environment');
  }

  factory MangopayClient.getInstance({
    String clientID,
    String clientPassword,
    String baseURL,
    MangopayEnvironment environment = MangopayEnvironment.SandBox,
    String version = 'v2.01',
  }) {
    if (_instance == null) {
      assert(
          isNotEmpty(clientID) && isNotEmpty(clientPassword),
          'Mangopay client requires some parameters to create an instance '
          '\n please provide all the required parameters.'
          '\n Optional parameters: '
          '\n\t `version (default=v2.0.1)`'
          '\n\t `environment (default=MangopayEnvironment.SandBox)`'
          '\n\t `baseURL (default value is based on environment`');

      _instance = MangopayClient._(
        clientID: clientID,
        clientPassword: clientPassword,
        url: baseURL,
        environment: environment,
        version: version,
      );
    }
    return _instance;
  }

  String get apiURL => '$baseURL/$version/$clientID';

  /// --- Registration, activation & authentication methods ---///

  Future<MangopayRegisterCardData> registerCardWithMangopayCard(
    String userID,
    MangopayCard mangopayCard, {
    String tag = MANGOPAY_TAG,
  }) async {
    final registerCardData = await getCardRegistrationData(
      userID: userID,
      cardType: mangopayCard.cardType,
      currency: mangopayCard.currency,
      tag: tag,
    );

    if (registerCardData != null && registerCardData.hasData) {
      final registrationData = await registerCardWithRegistrationData(
        registerCardData,
        mangopayCard,
      );

      if (registrationData != null && registrationData.hasData) {
        return registrationData;
      }
    }
    return null;
  }

  Future<MangopayRegisterCardData> getCardRegistrationData({
    String userID,
    String cardType,
    String tag = MANGOPAY_TAG,
    String currency,
  }) async {
    final url = apiURL + getRegisterCardSuffix();
    var headerData = getMangopayHeader(clientID, clientPassword);
    final parameters =
        _getParametersForCardRegistrationData(userID, cardType, tag, currency);

    final json = await fetchDataFromPostRequest<Map<String, dynamic>>(
      url: url,
      headerData: headerData,
      parameters: jsonEncode(parameters),
    );

    if (json == null) return null;

    final registerData = MangopayRegisterCardData.fromJson(json);

    return registerData;
  }

  Map<String, dynamic> _getParametersForCardRegistrationData(
      String userID, String cardType, String tag, String currency) {
    return {
      MangopayRegisterCardDataTags.Tag: tag,
      MangopayRegisterCardDataTags.UserId: userID,
      MangopayRegisterCardDataTags.Currency: currency,
      MangopayRegisterCardDataTags.CardType: cardType,
    };
  }

  Future<MangopayRegisterCardData> registerCardWithRegistrationData(
      MangopayRegisterCardData cardRegisterData, MangopayCard cardData) async {
    // 0. validate card data
    final validationError = Validator.validateCardDataWithCard(cardData);

    if (validationError != null) {
      throw Exception(validationError);
    }

    // Try to register card in two steps:

    // 1.get Payline token and then finish card registration with Mangopay API
    final response =
        await _registerCardUsingRegisterData(cardRegisterData, cardData);

    // 2. finish card registration with Mangopay API
    final updatedRegistration =
        await _completeRegistration(cardRegisterData.id, response);

    return updatedRegistration;
  }

  Future<String> _registerCardUsingRegisterData(
    MangopayRegisterCardData cardRegisterData,
    MangopayCard cardData,
  ) async {
    final url = cardRegisterData.cardRegistrationURL;

    final headers =
        appendFormHeader(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForRegistration(
      cardRegisterData.preregistrationData,
      cardRegisterData.accessKey,
      cardData.cardNumber,
      cardData.cvx,
      cardData.expirationDate,
    );

    final response = await fetchRawDataFromPost(
      url: url,
      headerData: headers,
      parameters: parameters,
      isJsonRequest: false,
    );
    if (response == null) return null;

    return response;
  }

  Map<String, dynamic> _getParametersForRegistration(
    String preregistrationData,
    String accessKey,
    String cardNumber,
    String cvx,
    String expirationDate,
  ) {
    return {
      MangopayRegisterCardTags.PreregistrationData: preregistrationData,
      MangopayRegisterCardTags.AccessKey: accessKey,
      MangopayRegisterCardTags.CardNumber: cardNumber,
      MangopayRegisterCardTags.CardCVX: cvx,
      MangopayRegisterCardTags.CardExpirationDate: expirationDate,
    };
  }

  Future<MangopayRegisterCardData> _completeRegistration(
      String id, String registrationData) async {
    final url = apiURL + getCompleteRegisterCardSuffix(id);
    final headers =
        appendFormHeader(getMangopayHeader(clientID, clientPassword));
    final parameters =
        _getParametersForRegistrationCompletion(registrationData);

    final json = await fetchDataFromPostRequest<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: parameters,
      isJsonRequest: false,
    );
    if (json == null) return null;
    final updatedRegistrationData = MangopayRegisterCardData.fromJson(json);
    return updatedRegistrationData;
  }

  Map<String, dynamic> _getParametersForRegistrationCompletion(
    String registrationData,
  ) {
    return {
      MangopayRegisterCardDataTags.RequestRegistrationData: registrationData,
    };
  }

  Future<MangopayCard> updateCardActivation(
    String cardID, {
    bool activation = true,
  }) async {
    final url = apiURL + getDeactivateCardSuffix(cardID);
    final headers =
        appendJSONHeaders(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForCardActivationUpdate(activation);

    final json = await putDataWithFormattedResponse<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: jsonEncode(parameters),
    );
    if (json == null) return null;
    final updatedRegistrationData = MangopayCard.fromJson(json);
    return updatedRegistrationData;
  }

  Map<String, dynamic> _getParametersForCardActivationUpdate(
    bool keepActive,
  ) {
    return {
      MangopayRegisterCardDataTags.RequestCardStatusData: keepActive.toString(),
    };
  }

  Future<Wallet> createUserWallet({
    String userID,
    String walletDescription,
    String currency,
    String tag = MANGOPAY_TAG,
  }) async {
    final url = apiURL + getCreateWalletSuffix();
    final headers =
        appendJSONHeaders(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForWalletCreation(
        userID: userID,
        walletDescription: walletDescription,
        currency: currency,
        tag: tag);

    final json = await fetchDataFromPostRequest<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: jsonEncode(parameters),
    );
    if (json == null) return null;
    final wallet = Wallet.fromJson(json);
    return wallet;
  }

  Map<String, dynamic> _getParametersForWalletCreation({
    String userID,
    String walletDescription,
    String currency,
    String tag = MANGOPAY_TAG,
  }) {
    return {
      WalletRequestTags.Owners: [userID],
      WalletRequestTags.Description: walletDescription,
      WalletRequestTags.Currency: currency,
      WalletRequestTags.Tag: tag,
    };
  }

  Future<MangopayUser> registerUser({
    String firstName,
    String lastName,
    String email,
    String nationality,
    String countryOfResidence,
    int birthdayTimeStamp,
  }) async {
    final url = apiURL + getRegisterUserSuffix();
    final headers =
        appendJSONHeaders(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForUserRegistration(
      firstName: firstName,
      lastName: lastName,
      email: email,
      nationality: nationality,
      countryOfResidence: countryOfResidence,
      birthdayTimeStamp: birthdayTimeStamp,
    );

    final json = await fetchDataFromPostRequest<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: jsonEncode(parameters),
    );
    if (json == null) return null;

    final user = MangopayUser.fromJson(json);
    return user;
  }

  Map<String, dynamic> _getParametersForUserRegistration({
    String firstName,
    String lastName,
    String email,
    String nationality,
    String countryOfResidence,
    int birthdayTimeStamp,
  }) {
    return {
      UserTags.RequestFirstName: firstName,
      UserTags.RequestLastName: lastName,
      UserTags.RequestEmail: email,
      UserTags.RequestBirthday: birthdayTimeStamp,
      UserTags.RequestNationality: nationality,
      UserTags.RequestCountryOfResidence: countryOfResidence,
    };
  }

  /// --- Data Fetch methods ---///

  Future<List<MangopayUser>> getUsers() async {
    final url = apiURL + getUsersSuffix();
    final headers = getMangopayHeader(clientID, clientPassword);

    final json = await fetchDataFromGetRequest<List>(
      url: url,
      headerData: headers,
    );
    if (json == null) return null;

    final users = json.map((element) {
      return MangopayUser.fromJson(element as Map<String, dynamic>);
    }).toList();
    return users;
  }

  Future<List<MangopayCard>> getCards({String userId}) async {
    assert(isNotEmpty(userId),
        'Mangopay client requires userId to fetch card details');

    final url = apiURL + getCardSuffix(userId);
    final headers = getMangopayHeader(clientID, clientPassword);

    final json = await fetchDataFromGetRequest<List>(
      url: url,
      headerData: headers,
    );
    if (json == null) return null;
    final cards = json.map((element) {
      return MangopayCard.fromJson(element as Map<String, dynamic>);
    }).toList();

    return cards;
  }

  /// --- Transaction methods ---///

  /// Return Transaction ID
  Future<String> directPayinUsingCard({
    String mangopayUserID,
    String mangopayWalletID,
    num investment,
    num fees = 0.0,
    String cardId,
    String currency,
    String secureModeReturnURL,
    String statementDescriptor,
  }) async {
    final url = apiURL + getDirectPayinSuffix();
    final headers =
        appendJSONHeaders(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForDirectPayin(
      mangopayUserID: mangopayUserID,
      mangopayWalletID: mangopayWalletID,
      cardId: cardId,
      currency: currency,
      investment: investment,
      fees: fees,
      secureModeReturnURL: secureModeReturnURL,
      statementDescriptor: statementDescriptor,
    );

    print('MangopayClient: directPayinUsingCard: url: $url');
    print('MangopayClient: directPayinUsingCard: headers: $headers');
    print('MangopayClient: directPayinUsingCard: parameters: $parameters');

    final json = await fetchDataFromPostRequest<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: jsonEncode(parameters),
    );

    if (json == null) return null;
    final status = json[MangopayTransactionRequestTags.ResponseStatus];

    if (status != MangopayTransactionRequestTags.StatusFailed) {
      final transactionID = json[MangopayTransactionRequestTags.ResponseID];
      return transactionID;
    } else {
      final code = json[MangopayTransactionRequestTags.ResponseResultCode];
      final message =
          json[MangopayTransactionRequestTags.ResponseResultMessage];
      throw Exception('$message, Error code: $code');
    }
  }

  Map<String, dynamic> _getParametersForDirectPayin({
    String mangopayUserID,
    String mangopayWalletID,
    String cardId,
    String currency,
    String secureModeReturnURL,
    num investment,
    num fees = 0.0,
    SecureMode secureMode = SecureMode.Default,
    String statementDescriptor,
  }) {
    return MangopayTransactionRequest.fromData(
            cardId: cardId,
            currency: currency,
            secureModeReturnURL: secureModeReturnURL,
            creditedWalletId: mangopayWalletID,
            authorId: mangopayUserID,
            amount: investment.toInt(),
            fees: fees.toInt(),
            secureMode: secureMode,
            statementDescriptor: statementDescriptor)
        .toJson();
  }
}
