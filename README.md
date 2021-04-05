# flutter_mangopay_client

[![pub package](https://img.shields.io/pub/v/flutter_mangopay_client.svg)](https://pub.dev/packages/flutter_mangopay_client)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A simple flutter client for Mangopay Payment gateway.

## Getting Started

#### Steps to follow for integration of this plugin:

 - create a new directory named "dependencies" (without quotes) in your flutter project's root directory

 - copy the directory & contents of this plugin to the dependencies directory

 - add following in the pubspec.yaml file of your project under `dependencies`:

   ```yaml
  flutter_mangopay_client:
    path: ../
   ```

 - Note that yaml file depends on indentation/spaces of the content to work properly

 - Run `flutter packages get` or `flutter pub get`

That is it, you should now be able to use the `MangopayClient` without any issues.


#### How to create client instance
```dart
    final mangoPayClient = MangopayClient.getInstance(
	  // [Required]
      clientID: 'CLIENT_ID',
	  // [Required]
      clientPassword: 'CLIENT_PASSWORD',
	  // [Optional]
	  baseURL: 'BASE_API_URL',
	  // [Optional]
	  // use for testing purpose => MangopayEnvironment.Sandbox
	  // use for app release => MangopayEnvironment.Production
      environment: MangopayEnvironment.SandBox,
	  // [Optional] API version
	  version: 'v2.01',
    );
```

## Features:

#### Fetch all registered users
```dart
    final List<MangopayUser> users = await mangoPayClient.getUsers();
```

#### Fetch all registered cards for a user
```dart
/// use the same client ID as the one used for registrations
    final List<MangopayCard> cards = await mangoPayClient.getCards(
	  // [Required]
      userId: 'MANGOPAY_USER_ID',
    );
```

#### Register a card
```dart
    /// create a mangopay card for registration
    final mangopayCard = MangopayCard.fromUserData(
	  // 16 digit card number
      cardNumber: 'CardNumber',
      cvv: 'CardCVV',
	  // Month in MM format
      expirationMonth: 'ExpiryMonth',
	  // Year in YY format
      expirationYear: 'ExpiryYear',
	  //currency in ISO 4217 format
      currency: 'Currency',
      userID: 'MangoPayUserID',
	  // [Optional]
	  tag: 'UNIQUE_TAG',
    );

	/// perform Mangopay card registration
	final registerCardData = await mangoPayClient
	.registerCardWithMangopayCard(
		'MangoPayUserID',
		mangopayCard,
	);


```

**Note**: Refer to [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) for more details about currency format

#### Register a User [Natural]
```dart
	final mangopayUser = await mangoPayClient
        .registerNaturalUser(
            firstName: 'John',
            lastName: 'doe',
            email: 'john.doe@example.com',
            countryOfResidence: 'FR',
            nationality: 'FR',
            birthdayTimeStamp:
                (DateTime.parse('1974-01-04')
					.millisecondsSinceEpoch ~/ 1000)
		);
```
**Note**: birth date must be in [UNIX timestamp](https://www.epochconverter.com/) format.



#### Create a wallet for registered user
```dart
	final wallet = await mangoPayClient.createUserWallet(
        userID: 'MangoPayUserID',
		//currency in ISO 4217 format
        currency: 'currency',
        walletDescription: 'Any valid short description',
		// [Optional]
		tag: 'UNIQUE_TAG',
	);
```
**Note**: Refer to [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) for more details about currency format


#### Perform DirectPayin transaction using card
```dart
	final transactionID = await mangoPayClient
          .directPayinUsingCard(
		//currency in ISO 4217 format
        currency: 'currency',
		// valid registered card ID
        cardId: 'CardID',
		// amount type = number (int)
        amount: 149,
		// fees type = number (int)
        fees: 6,
        secureModeReturnURL: 'SECURE_RETURN_URL',
        mangopayUserID: 'MangoPayUserID',
        mangopayWalletID: 'RecipientWalletID',
      )
```
**Notes**:

 - Refer to [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) for more details about currency format

 - `CardID` can be obtained from already registered cards or recently obtained card registration data

 - `SECURE_RETURN_URL` should be a valid url, but it can be any valid url, including `https://google.com`

 - `RecipientWalletID` should be a wallet ID of a valid Mangopay User

#### Deactivate a card
```dart
	final MangopayCard deactivatedCard = await mangoPayClient
            .deactivateCard(
          // valid registered card ID
          cardId: 'CardID',
		  // [Optional]
          isCurrentlyActivated: true,
        );
```

## Issues & Support

- File an issue on the repository, if something is not working as expected.
   - Please Use `[Bug]` or `[Issue]` tags in issue titles.
   - Please follow the issue template used in flutter-sdk's repository, may be we'll integrate that here as well.

- File an issue in the repository, If you have any suggestions and/or feature requests
   - Please Use `[Suggestion]` or `[Request]` tags in issue titles.