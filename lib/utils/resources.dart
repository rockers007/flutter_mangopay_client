/// The default time out duration used in all of the HTTP communication
/// done in this package
const defaultTimeoutDuration = Duration(seconds: 30);

/// API url for Sandbox environment
const String MANGOPAY_SANDBOX_URL = 'https://api.sandbox.mangopay.com';

/// API url for production environment
const String MANGOPAY_PRODUCTION_URL = 'https://api.mangopay.com';

/// A Simple tag value used for unique identification of data. [Use is optional]
const String MANGOPAY_TAG = 'flutter_mangopay_client';

/// A Simple tag value used to represent most of the VISA & MasterCard cards
const String MANGOPAY_VISA_MC_CARD_TYPE = 'CB_VISA_MASTERCARD';

/// --- Api Tags --- ///

abstract class UserTags {
  static const String PersonType = 'PersonType';
  static const String KYCLevel = 'KYCLevel';
  static const String Email = 'Email';
  static const String ID = 'Id';
  static const String Tag = 'Tag';
  static const String CreationDate = 'CreationDate';

  static const String RequestFirstName = 'FirstName';
  static const String RequestLastName = 'LastName';
  static const String RequestEmail = 'Email';
  static const String RequestBirthday = 'Birthday';
  static const String RequestNationality = 'Nationality';
  static const String RequestCountryOfResidence = 'CountryOfResidence';
}

abstract class MangopayCardTags {
  static const String ExpirationDate = 'ExpirationDate';
  static const String Alias = 'Alias';
  static const String CardType = 'CardType';
  static const String CardProvider = 'CardProvider';
  static const String Country = 'Country';
  static const String Product = 'Product';
  static const String BankCode = 'BankCode';
  static const String Active = 'Active';
  static const String Currency = 'Currency';
  static const String Validity = 'Validity';
  static const String UserId = 'UserId';
  static const String Id = 'Id';
  static const String Tag = 'Tag';
  static const String CreationDate = 'CreationDate';
  static const String Fingerprint = 'Fingerprint';
}

abstract class MangopayRegisterCardDataTags {
  static const String RequestRegistrationData = "RegistrationData";
  static const String RequestCardCurrentActivationStatusData = "Active";

  static const String CardType = 'CardType';
  static const String Currency = 'Currency';
  static const String UserId = 'UserId';
  static const String Tag = 'Tag';
  static const String Id = "Id";
  static const String CreationDate = "CreationDate";
  static const String AccessKey = "AccessKey";
  static const String PreregistrationData = "PreregistrationData";
  static const String RegistrationData = "RegistrationData";
  static const String CardId = "CardId";
  static const String CardRegistrationURL = "CardRegistrationURL";
  static const String ResultCode = "ResultCode";
  static const String ResultMessage = "ResultMessage";
  static const String Status = "Status";
}

abstract class MangopayRegisterCardTags {
  static const String PreregistrationData = "data";
  static const String AccessKey = "accessKeyRef";
  static const String CardNumber = 'cardNumber';
  static const String CardExpirationDate = 'cardExpirationDate';
  static const String CardCVX = 'cardCvx';
}

abstract class MangopayTransactionRequestTags {
  static const String StatusFailed = 'FAILED';

  static const String ResponseStatus = 'Status';
  static const String ResponseResultCode = 'ResultCode';
  static const String ResponseResultMessage = 'ResultMessage';
  static const String ResponseID = 'Id';

  static const String AuthorId = 'AuthorId';
  static const String DebitedFunds = 'DebitedFunds';
  static const String Fees = 'Fees';
  static const String CreditedWalletId = 'CreditedWalletId';
  static const String SecureModeReturnURL = 'SecureModeReturnURL';
  static const String SecureMode = 'SecureMode';
  static const String CardID = 'CardID';
  static const String Tag = 'Tag';
  static const String StatementDescriptor = 'StatementDescriptor';
}

abstract class MangopayMoneyTags {
  static const String Currency = 'Currency';
  static const String Amount = 'Amount';
}

abstract class WalletRequestTags {
  static const String Owners = 'Owners';
  static const String Description = 'Description';
  static const String Currency = 'Currency';
  static const String Tag = 'Tag';
}

abstract class WalletTags {
  static const String Description = 'Description';
  static const String Owners = 'Owners';
  static const String Balance = 'Balance';
  static const String Currency = 'Currency';
  static const String FundsType = 'FundsType';
  static const String Id = 'Id';
  static const String Tag = 'Tag';
  static const String CreationDate = 'CreationDate';
}