import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mangopay_client/flutter_mangopay_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mangopay_client/utils.dart';

import 'form_input_field.dart';

const String CLIENT_ID = 'paulcrowdfunding';
const String CLIENT_PASSWORD = 'P@ssw0rd';
const String BASE_API_URL = 'https://api.sandbox.mangopay.com';
const String SECURE_RETURN_URL = 'https://google.com';

const String visaLogo =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Visa_2014_logo_detail.svg/1920px-Visa_2014_logo_detail.svg.png';
const String masterCardLogo =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png';

class PaymentPage extends StatefulWidget {
  final num investmentAmount;

  PaymentPage({
    Key key,
    this.investmentAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  // String _cardHoldersName;
  String _cardNumber;
  String _cardCVV;
  String _expiryMonth;
  String _expiryYear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 400,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCardUI(),
                buildRoundButton(
                  title: 'Invest',
                  onTap: () {
                    EasyLoading.show()
                        .then((_) => _proceedWithInvestment(context))
                        .whenComplete(() => EasyLoading.dismiss());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardUI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputField(
            title: 'Card Number',
            primaryPadding: EdgeInsets.zero,
            secondaryPadding: EdgeInsets.zero,
            hintColor: Colors.grey,
            borderColor: Colors.grey.shade700,
            validator: cardNumberValidator,
            inputType: TextInputType.number,
            enforceUnderLineBorder: false,
            inputAction: TextInputAction.next,
            suffixIcon: _getCardIcon(),
            onChange: (value) {
              _cardNumber = value;
              setState(() {});
            },
          ),
          SizedBox(height: 16.0),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: FormInputField(
                    title: 'MM',
                    primaryPadding: EdgeInsets.zero,
                    secondaryPadding: EdgeInsets.zero,
                    hintColor: Colors.grey,
                    borderColor: Colors.grey.shade700,
                    inputType: TextInputType.number,
                    validator: notEmptyValidator,
                    enforceUnderLineBorder: false,
                    inputAction: TextInputAction.next,
                    onChange: (value) {
                      _expiryMonth = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 12.0),
                Flexible(
                  flex: 1,
                  child: FormInputField(
                    title: 'YYYY',
                    primaryPadding: EdgeInsets.zero,
                    secondaryPadding: EdgeInsets.zero,
                    hintColor: Colors.grey,
                    borderColor: Colors.grey.shade700,
                    inputType: TextInputType.number,
                    validator: notEmptyValidator,
                    inputAction: TextInputAction.next,
                    enforceUnderLineBorder: false,
                    onChange: (value) {
                      _expiryYear = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 12.0),
                Flexible(
                  flex: 2,
                  child: FormInputField(
                    title: 'CVV',
                    primaryPadding: EdgeInsets.zero,
                    secondaryPadding: EdgeInsets.zero,
                    hintColor: Colors.grey,
                    borderColor: Colors.grey.shade700,
                    inputType: TextInputType.number,
                    validator: cardCVVNumberValidator,
                    inputAction: TextInputAction.next,
                    enforceUnderLineBorder: false,
                    onChange: (value) {
                      _cardCVV = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          FormInputField(
            title: 'Name on Card',
            primaryPadding: EdgeInsets.zero,
            secondaryPadding: EdgeInsets.zero,
            hintColor: Colors.grey,
            borderColor: Colors.grey.shade700,
            validator: notEmptyValidator,
            enforceUnderLineBorder: false,
            inputAction: TextInputAction.go,
            onChange: (value) {
              // _cardHoldersName = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _getCardIcon() {
    if (isEmpty(_cardNumber)) return SizedBox();
    var _imageUrl = _cardNumber.startsWith('4') ? visaLogo : masterCardLogo;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CachedNetworkImage(
        imageUrl: _imageUrl,
        width: 16,
      ),
    );
  }

  Future<void> _proceedWithInvestment(BuildContext context) async {
    final isAllValidated = _formKey.currentState.validate();
    if (isAllValidated) {
      /// save all the values if validation passes
      _formKey.currentState.save();
      await _processMangoPayDetails(context);
    }
  }

  Future<void> _processMangoPayDetails(BuildContext context) async {
    final currency = 'GBP';

    var mangoPayID;
    var mangoPayWalletID;
    // Create mango pay client from the fetched gateway details
    final mangoPayClient = MangopayClient.getInstance(
      clientID: CLIENT_ID,
      clientPassword: CLIENT_PASSWORD,
      baseURL: BASE_API_URL,
      environment: MangoPayEnvironment.SandBox,
    );

    print('mangoPayClient:');
    print('\n\t${mangoPayClient.clientID}');
    print('\n\t${mangoPayClient.clientPassword}');
    print('\n\t${mangoPayClient.environment}');
    print('\n\t${mangoPayClient.apiURL}');
    print('User is not registered with the mangopay gateway');
    mangoPayID = await mangoPayClient
        .registerUser(
            firstName: 'John',
            lastName: 'doe',
            email: 'john.doe@example.com',
            countryOfResidence: 'FR',
            nationality: 'FR',
            birthdayTimeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000)
        .catchError((e, s) {
      print('_processMangoPayDetails: $e \n$s');
      return null;
    });
    print('mangoPayID: $mangoPayID');

    // create a mangocard instance from user's input
    final mangoCard = MangopayCard.fromUserData(
      cardNumber: _cardNumber,
      cvv: _cardCVV,
      expirationMonth: _expiryMonth,
      expirationYear: _expiryYear,
      currency: currency,
      userID: mangoPayID,
    );

    print('mangoCard: $mangoCard');
    // Register card, save this registerCardData in the storage along with the mangocard instance
    final registerCardData =
        await mangoPayClient.registerCard(mangoPayID, mangoCard);

    print('registerCardData: $registerCardData');
    // check if registration is successful or not
    if (registerCardData != null) {
      // deactivate new card
      // final data2 = await mangoPayClient.deactivateCard(registerCardData.cardId);

      final wallet = await mangoPayClient.createUserWallet(
          userID: mangoPayID,
          currency: currency,
          walletDescription: 'Wallet for $currency');

      print('wallet: $wallet');
      mangoPayWalletID = wallet.id;

      var errorMessage;
      final transactionID = await mangoPayClient
          .directPayinUsingCard(
        mangopayCard: mangoCard,
        registerCardData: registerCardData,
        investment: widget.investmentAmount,
        secureModeReturnURL: SECURE_RETURN_URL,
        mangopayUserID: mangoPayID,
        mangopayWalletID: mangoPayWalletID,
      )
          .catchError((e) {
        print(e.toString());
        errorMessage = e.toString();
        return null;
      });

      print('transactionID: $transactionID');
      if (isNotEmpty(transactionID) && transactionID is String) {
        return transactionID;
      } else {
        throw Exception('Invalid Transaction ID: $transactionID,'
            ' error: $errorMessage');
      }
    }
  }

  Widget buildRoundButton({
    String title = 'Continue',
    Color buttonColor = Colors.blueAccent,
    Color textColor = Colors.white,
    VoidCallback onTap,
    double outerHorizontalPadding,
    double outerVerticalPadding,
    double innerHorizontalPadding,
    double innerVerticalPadding,
    double radius,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: outerHorizontalPadding ?? 64,
        vertical: outerVerticalPadding ?? 4,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 50),
            color: buttonColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: innerHorizontalPadding ?? 16,
              vertical: innerVerticalPadding ?? 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
