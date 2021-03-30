import 'dart:convert';

import 'mangopay_client.dart';
import 'utils/common_utils.dart';
import 'utils/resources.dart';
import 'utils.dart';

enum MangoPayEnvironment {
  SandBox,
  Production,
}

class MangopayClient {
  String clientID;
  String clientPassword;
  String userID;
  String baseURL;
  String version;
  MangoPayEnvironment environment;

  static MangopayClient _instance;

  MangopayClient._({
    this.clientID = '',
    this.clientPassword = '',
    this.userID = '',
    String url,
    this.environment = MangoPayEnvironment.SandBox,
    this.version = 'v2.01',
  }) {
    url ??= _getApiUrl(environment);
    this.baseURL = url;
  }

  static String _getApiUrl(MangoPayEnvironment environment) {
    switch (environment) {
      case MangoPayEnvironment.SandBox:
        return MANGO_PAY_SANDBOX_URL;
      case MangoPayEnvironment.Production:
        return MANGO_PAY_PRODUCTION_URL;
    }
    throw Exception('Unknown Environment type: $environment');
  }

  factory MangopayClient.getInstance({
    String clientID,
    String clientPassword,
    String userID,
    String baseURL,
    MangoPayEnvironment environment = MangoPayEnvironment.SandBox,
    String version = 'v2.01',
  }) {
    if (_instance == null) {
      assert(
          isNotEmpty(clientID) &&
              isNotEmpty(clientPassword) &&
              isNotEmpty(userID),
          'Mangopay client requires some parameters to create an instance '
          '\n please provide all the required parameters.'
          '\n Optional parameters: '
          '\n\t `version (default=v2.0.1)`'
          '\n\t `environment (default=MangoPayEnvironment.SandBox)`'
          '\n\t `baseURL (default value is based on environment`');

      _instance = MangopayClient._(
        clientID: clientID,
        clientPassword: clientPassword,
        userID: userID,
        url: baseURL,
        environment: environment,
        version: version,
      );
    }
    return _instance;
  }

  String get apiURL => '$baseURL/$version/$clientID';

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
    final url = apiURL + getCardSuffix(userId ?? userID);
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

  Future<MangopayRegisterCardData> registerCard(
    String userID,
    MangopayCard mangoCard,
  ) async {
    final registerCardData = await getCardRegistrationData(
      userID: userID,
      cardType: mangoCard.cardType,
      currency: mangoCard.currency,
      tag: mangoCard.tag,
    );

    if (registerCardData != null && registerCardData.hasData) {
      final registrationData = await registerCardWithData(
        registerCardData,
        mangoCard,
      );

      if (registrationData != null && registrationData.hasData) {}
      return registrationData;
    }
    return null;
  }

  Future<MangopayRegisterCardData> getCardRegistrationData({
    String userID,
    String cardType,
    String tag = MANGO_PAY_TAG,
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

  Future<MangopayRegisterCardData> registerCardWithData(
      MangopayRegisterCardData cardRegisterData, MangopayCard cardData) async {
    // 0. validate card data
    final validationError = Validator.validateCardDataWithCard(cardData);

    if (validationError != null) {
      throw Exception(validationError);
    }

    // Try to register card in two steps:

    // 1.get Payline token and then finish card registration with MangoPay API
    final response =
        await _registerCardUsingRegisterData(cardRegisterData, cardData);

    // 2. finish card registration with MangoPay API
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

  Future<MangopayCard> deactivateCard(
    String cardID, {
    bool keepActive = false,
  }) async {
    final url = apiURL + getDeactivateCardSuffix(cardID);
    final headers =
        appendJSONHeaders(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForCardDeactivation(keepActive);

    final json = await putDataWithFormattedResponse<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: jsonEncode(parameters),
    );
    if (json == null) return null;
    final updatedRegistrationData = MangopayCard.fromJson(json);
    return updatedRegistrationData;
  }

  Map<String, dynamic> _getParametersForCardDeactivation(
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
    String tag = MANGO_PAY_TAG,
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
    String tag = MANGO_PAY_TAG,
  }) {
    return {
      WalletRequestTags.Owners: [userID],
      WalletRequestTags.Description: walletDescription,
      WalletRequestTags.Currency: currency,
      WalletRequestTags.Tag: tag,
    };
  }

  Future<String> registerUser({
    String firstName,
    String lastName,
    String email,
    String nationality,
    String countryOfResidence,
    int birthdayTimeStamp,
    String tag = MANGO_PAY_TAG,
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
        tag: tag);

    final json = await fetchDataFromPostRequest<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: jsonEncode(parameters),
    );
    if (json == null) return null;

    final userID = json[UserTags.ID];
    return userID;
  }

  Map<String, dynamic> _getParametersForUserRegistration({
    String firstName,
    String lastName,
    String email,
    String nationality,
    String countryOfResidence,
    int birthdayTimeStamp,
    String tag = MANGO_PAY_TAG,
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

  /// Return Transaction ID
  Future<String> directPayinUsingCard({
    String mangopayUserID,
    String mangopayWalletID,
    num investment,
    num fees = 0.0,
    MangopayRegisterCardData registerCardData,
    MangopayCard mangopayCard,
    String secureModeReturnURL,
    String statementDescriptor,
  }) async {
    final url = apiURL + getDirectPayinSuffix();
    final headers =
        appendJSONHeaders(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForDirectPayin(
      mangopayUserID: mangopayUserID,
      mangopayWalletID: mangopayWalletID,
      registerCardData: registerCardData,
      mangopayCard: mangopayCard,
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
    MangopayRegisterCardData registerCardData,
    MangopayCard mangopayCard,
    String secureModeReturnURL,
    num investment,
    num fees,
    SecureMode secureMode = SecureMode.Default,
    String statementDescriptor,
  }) {
    return MangopayTransactionRequest.fromData(
            mangopayCard: mangopayCard,
            registerCardData: registerCardData,
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
