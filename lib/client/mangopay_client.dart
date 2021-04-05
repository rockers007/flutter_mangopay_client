import 'dart:convert';

import '../models/models.dart';
import '../utils/utils.dart';
import 'client_helper.dart';

enum MangopayEnvironment {
  SandBox,
  Production,
}

/// This is the client that is used to process & perform transactions with mangopay api
///
/// Currently following operations are supported by this client:
///  - Fetch all registered cards
///  - Fetch all registered users
///  - Register a card
///  - Register a User [Natural]
///  - Create a wallet for registered user
///  - Perform DirectPayin transaction using card
///  - Deactivate a card
///
/// For more details on these operations & other non-supported operations
/// please check the mangopay api documentation:
///  https://docs.mangopay.com/endpoints/v2.01
class MangopayClient {
  /// The client ID of a registered client, this ID is provided by mangopay
  /// It is basically the id part of the login credentials provided to a client
  ///
  /// This id is available to user for both sandbox & production environments
  ///
  /// You can use following for testing purposes:
  /// demo
  String clientID;

  /// The client password/secret/api key of a registered client, this is provided by mangopay
  /// This is different then the password used for logging in to the dashboard
  /// of mangopay
  ///
  /// You can use following for testing purposes:
  /// SRbaqf9kwpjOxAYtE9tVFVBWAh2waeF7TX4TEcZ4jVFKbm1uaD
  String clientPassword;

  /// The base url of mangopay api
  ///
  /// This value is *optional* as we already have two default base urls
  /// for the communication based on the environment type:
  ///  - [MANGOPAY_SANDBOX_URL]
  ///  - [MANGOPAY_PRODUCTION_URL]
  ///
  ///
  /// If this value is not provided then the url will be selected based on the
  /// [environment] value
  String baseURL;

  /// Version of the api to be communicated with
  /// This value is *optional* as we already have default value
  /// as v2.01
  ///
  /// provide this value only if you want to communicate with some other version
  /// of the mangopay api
  String version;

  /// The environment type of the mangopay api
  /// This value if not directly used anywhere but to only to decide the base api url
  /// for the client to communicate with
  ///
  /// Following environments are supported:
  ///  - [MangopayEnvironment.SandBox] (default)
  ///  - [MangopayEnvironment.Production]
  ///
  /// Note: make sure to provide environment value as [MangopayEnvironment.Production]
  /// when releasing the product.
  MangopayEnvironment environment;

  /// Singleton instance of the client
  static MangopayClient _instance;

  /// Private constructor
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

  /// Utility method to get base api url based on [environment]
  static String _getApiUrl(MangopayEnvironment environment) {
    switch (environment) {
      case MangopayEnvironment.SandBox:
        return MANGOPAY_SANDBOX_URL;
      case MangopayEnvironment.Production:
        return MANGOPAY_PRODUCTION_URL;
    }
    throw Exception('Unknown Environment type: $environment');
  }

  /// Factory method to initialize the client instance if null & return the instance
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

  /// getter for api url for direct communication
  String get apiURL => '$baseURL/$version/$clientID';

  /// --- User Specific methods ---///

  /// Method to fetch all the users registered by this client
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

  /// Method to register a natural mangopay user
  ///
  /// There are two types of users in mangopay:
  ///  - Natural: https://docs.mangopay.com/endpoints/v2.01/users#e254_the-natural-user-object
  ///  - Legal: https://docs.mangopay.com/endpoints/v2.01/users#e258_the-legal-user-object
  ///
  /// This method is only for registering Natural users.
  Future<MangopayUser> registerNaturalUser({
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

  /// Method to generate a map of parameters for user registration
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

  /// --- Card Specific methods ---///

  /// Method to fetch all cards registered by user of this client
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

  /// A Helper Method to register card using the details provided
  /// from user input
  Future<MangopayRegisterCardData> registerCardWithMangopayCard(
    String userID,
    MangopayCard mangopayCard, {
    String tag = MANGOPAY_TAG,
  }) async {
    // Step #1: get card registration data from the mangopay api
    final registerCardData = await getCardRegistrationData(
      userID: userID,
      cardType: mangopayCard.cardType,
      currency: mangopayCard.currency,
      tag: tag,
    );

    // Step #2: register using registration data from the mangopay api
    if (registerCardData != null && registerCardData.hasData) {
      final responseRegistrationData = await registerCardWithRegistrationData(
        registerCardData,
        mangopayCard,
      );

      // Step #3: validate the registration response
      if (responseRegistrationData != null &&
          responseRegistrationData.hasData) {
        return responseRegistrationData;
      }
    }
    return null;
  }

  /// This method is the Step #1 in the card registration process
  ///
  /// This method takes in meta details of the card & registers it
  /// with the mangopay api to start registration process
  ///
  /// Response of this method is a direct input for the Step #2 of this process
  ///
  /// Refer to this for more details:
  /// https://docs.mangopay.com/endpoints/v2.01/cards#e178_create-a-card-registration
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

  /// Method to generate a map of parameters for card meta data registration
  Map<String, dynamic> _getParametersForCardRegistrationData(
      String userID, String cardType, String tag, String currency) {
    return {
      MangopayRegisterCardDataTags.Tag: tag,
      MangopayRegisterCardDataTags.UserId: userID,
      MangopayRegisterCardDataTags.Currency: currency,
      MangopayRegisterCardDataTags.CardType: cardType,
    };
  }

  /// This method is the Step #2 in the card registration process
  ///
  /// This method takes in the response from the Step #1 and uses it to provide
  /// the actual card's details for registration
  ///
  /// This method will first validate the card data & then proceed with the
  /// registration process, if card details are invalid then registration
  /// process will interrupted with an exception containing related message
  ///
  /// Response of this method is the final response of this whole registration process
  /// Along with various data, this response will contain a [cardId] which is
  /// the registration id of the card details that is used for registration
  Future<MangopayRegisterCardData> registerCardWithRegistrationData(
      MangopayRegisterCardData cardRegisterData, MangopayCard cardData) async {
    // 0. validate card data
    final validationError = Validator.validateCardDataWithCard(cardData);

    if (validationError != null) {
      throw Exception(validationError);
    }

    // Register card in two steps:

    // 1.get Payline token and then finish card registration with Mangopay API
    final response =
        await _registerCardUsingRegisterData(cardRegisterData, cardData);

    // 2. finish card registration with Mangopay API
    final updatedRegistration =
        await _completeRegistration(cardRegisterData.id, response);

    return updatedRegistration;
  }

  /// Intermediate part 1 of the step 3
  ///
  /// This method will Post the card's actual details to proceed with
  /// the registration process.
  ///
  /// Response of this method will be a registration token string
  ///
  /// Refer to this for more details:
  /// https://docs.mangopay.com/endpoints/v2.01/cards#e1042_post-card-info
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

  /// Method to generate a map of parameters for card's details registration
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

  /// Intermediate part 2 of the step 3
  ///
  /// This method will Post the registration token obtained from the intermediate part 1.
  /// This step is optional but performing this step ensures that user does face any
  /// authentication issues in the future.
  ///
  /// Response of this method will be an instance [MangopayRegisterCardData]
  /// This instance contains almost everything that will be required for future
  /// references to the card details that was registered
  ///
  /// Refer to this for more details:
  /// https://docs.mangopay.com/endpoints/v2.01/cards#e179_update-a-card-registration
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

  /// Method to generate a map of parameters for card registration completion
  Map<String, dynamic> _getParametersForRegistrationCompletion(
    String registrationData,
  ) {
    return {
      MangopayRegisterCardDataTags.RequestRegistrationData: registrationData,
    };
  }

  /// Method to deactivate a registered card
  ///
  /// Response of this method will be an instance of the mangopay card
  /// with updated details.
  ///
  /// Note that once deactivated, a card can't be reactivated afterwards
  ///
  /// Refer to this for more details:
  /// https://docs.mangopay.com/endpoints/v2.01/cards#e182_deactivate-a-card
  Future<MangopayCard> deactivateCard(
    String cardID, {
    bool isCurrentlyActivated = true,
  }) async {
    if (!Validator.validateID(cardID)) {
      throw Exception('Invalid cardID: $cardID');
    }

    final url = apiURL + getDeactivateCardSuffix(cardID);
    final headers =
        appendJSONHeaders(getMangopayHeader(clientID, clientPassword));
    final parameters = _getParametersForCardDeactivation(
      isCurrentlyActivated: isCurrentlyActivated,
    );

    final json = await putDataWithFormattedResponse<Map<String, dynamic>>(
      url: url,
      headerData: headers,
      parameters: jsonEncode(parameters),
    );
    if (json == null) return null;
    final updatedCard = MangopayCard.fromJson(json);
    return updatedCard;
  }

  /// Method to generate a map of parameters for card deactivation
  Map<String, dynamic> _getParametersForCardDeactivation({
    bool isCurrentlyActivated = true,
  }) {
    return {
      MangopayRegisterCardDataTags.RequestCardCurrentActivationStatusData:
          isCurrentlyActivated.toString(),
    };
  }

  /// --- Wallet Specific methods ---///

  /// Method to crete a mangopay wallet for a registered user
  ///
  /// This method will create a wallet using the details provided.
  ///
  /// Response of this method is an instance of [MangopayWallet]
  Future<MangopayWallet> createUserWallet({
    String userID,
    String walletDescription,
    String currency,
    String tag = MANGOPAY_TAG,
  }) async {
    if (!Validator.validateID(userID)) {
      throw Exception('Invalid userID: $userID');
    }

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
    final wallet = MangopayWallet.fromJson(json);
    return wallet;
  }

  /// Method to generate a map of parameters for wallet creation
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

  /// --- Transaction methods ---///

  /// Method to perform a transaction from mangopay api
  /// using direct payin method & a registered card
  ///
  /// Note that the input of [amount] & [fees] is of type [num]
  /// but for the final transaction, both will be converted to [int].
  ///
  /// Please refer to following more details on this:
  /// https://docs.mangopay.com/endpoints/v2.01/payins#e278_create-a-card-direct-payin
  Future<String> directPayinUsingCard({
    String mangopayUserID,
    String mangopayWalletID,
    num amount,
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
      amount: amount,
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

  /// Method to generate a map of parameters for direct payin process
  Map<String, dynamic> _getParametersForDirectPayin({
    String mangopayUserID,
    String mangopayWalletID,
    String cardId,
    String currency,
    String secureModeReturnURL,
    num amount,
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
            amount: amount.toInt(),
            fees: fees.toInt(),
            secureMode: secureMode,
            statementDescriptor: statementDescriptor)
        .toJson();
  }
}
