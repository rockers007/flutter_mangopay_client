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
