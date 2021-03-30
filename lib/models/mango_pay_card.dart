import 'package:json_annotation/json_annotation.dart';

import '../utils.dart';

/*{
        "ExpirationDate": "1020",
        "Alias": "424242XXXXXX4242",
        "CardType": "CB_VISA_MASTERCARD",
        "CardProvider": "unknown",
        "Country": "unknown",
        "Product": "unknown",
        "BankCode": "unknown",
        "Active": true,
        "Currency": "USD",
        "Validity": "UNKNOWN",
        "UserId": "85809529",
        "Id": "86117367",
        "Tag": null,
        "CreationDate": 1597840258,
        "Fingerprint": "f5de72ec2cff469ea9546ae5de9ff811"
    }*/

part 'mango_pay_card.g.dart';

@JsonSerializable(explicitToJson: true)
class MangopayCard {
  @JsonKey(name: MangopayCardTags.ExpirationDate)
  final String expirationDate;
  @JsonKey(name: MangopayCardTags.Alias)
  final String alias;
  @JsonKey(name: MangopayCardTags.CardType)
  final String cardType;
  @JsonKey(name: MangopayCardTags.CardProvider)
  final String cardProvider;
  @JsonKey(name: MangopayCardTags.Country)
  final String country;
  @JsonKey(name: MangopayCardTags.Product)
  final String product;
  @JsonKey(name: MangopayCardTags.BankCode)
  final String bankCode;
  @JsonKey(name: MangopayCardTags.Active)
  final bool active;
  @JsonKey(name: MangopayCardTags.Currency)
  final String currency;
  @JsonKey(name: MangopayCardTags.Validity)
  final String validity;
  @JsonKey(name: MangopayCardTags.UserId)
  final String userID;
  @JsonKey(name: MangopayCardTags.Id)
  final String id;
  @JsonKey(name: MangopayCardTags.Tag)
  final String tag;
  @JsonKey(name: MangopayCardTags.CreationDate)
  final double creationDateInMills;
  @JsonKey(name: MangopayCardTags.Fingerprint)
  final String fingerprint;
  final String cvx;
  final String cardNumber;

  MangopayCard(
      {this.expirationDate,
      this.alias,
      this.cardType,
      this.cardProvider,
      this.country,
      this.product,
      this.bankCode,
      this.active,
      this.currency,
      this.validity,
      this.userID,
      this.id,
      this.tag,
      this.creationDateInMills,
      this.fingerprint,
      this.cardNumber,
      this.cvx});

  Map<String, dynamic> toJson() => _$MangopayCardToJson(this);

  factory MangopayCard.fromJson(Map<String, dynamic> json) =>
      _$MangopayCardFromJson(json);

  @override
  String toString() {
    return 'MangopayCard{expirationDate: $expirationDate, alias: $alias, cardType: $cardType, active: $active, currency: $currency, validity: $validity, userID: $userID, id: $id, creationDateInMills: $creationDateInMills}';
  }

  /// Create a mangoPay card using Test/Sandbox data provided by the Mangopay API
  ///
  /// Sandbox data for testing:
  ///  card number: 4970104100876588
  ///  cardType: CB_VISA_MASTERCARD [default]
  ///  cvx: any 3 digit number
  ///  expirationDate: any date in MMYY format,
  ///    MM = number of month in a year, starting from 1 to 12
  ///    YY = last two digits of year
  ///
  /// more information: https://docs.mangopay.com/guide/testing-payments
  static MangopayCard testCard({String currency, String userID}) {
    return MangopayCard(
        tag: MANGO_PAY_TAG,
        currency: currency,
        cardType: 'CB_VISA_MASTERCARD',
        cardNumber: '4970104100876588',
        cvx: '111',
        userID: userID,
        expirationDate: '1234');
  }

  /// Create a mangoPay card using data provided by user
  ///
  ///  card number: Valid 16 digit card number
  ///  cardType: CB_VISA_MASTERCARD [default]
  ///  cvx: valid 3 digit number
  ///  expirationDate: Expiry in MMYY format,
  ///    MM = number of month in a year, starting from 01 to 12
  ///    YY = last two digits of year
  factory MangopayCard.fromUserData({
    String cardNumber,
    String cvv,
    String expirationMonth,
    String expirationYear,
    String currency,
    String userID,
  }) {
    return MangopayCard(
        tag: MANGO_PAY_TAG,
        currency: currency,
        cardType: MANGO_PAY_CARD_TYPE,
        cardNumber: cardNumber,
        cvx: cvv,
        userID: userID,
        expirationDate: '$expirationMonth$expirationYear');
  }
}
