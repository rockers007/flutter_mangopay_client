import 'package:json_annotation/json_annotation.dart';

import '../mangopay_client.dart';
import '../utils.dart';

part 'mango_pay_transaction_request.g.dart';

enum SecureMode {
  /// lets you ask for an Frictionless payment
  @JsonValue('DEFAULT')
  Default,

  /// allows you to make the transaction eligible for Frictionless, but the exemption will be applied by the other payment actors
  @JsonValue('NO_CHOICE')
  NoChoice,

  /// forces customer authentication
  @JsonValue('FORCE')
  Force,
}

@JsonSerializable(explicitToJson: true)
class MangopayTransactionRequest {
  @JsonKey(name: MangopayTransactionRequestTags.AuthorId)
  final String authorId;
  @JsonKey(name: MangopayTransactionRequestTags.DebitedFunds)
  final MangopayMoney debitedFunds;
  @JsonKey(name: MangopayTransactionRequestTags.Fees)
  final MangopayMoney fees;
  @JsonKey(name: MangopayTransactionRequestTags.CreditedWalletId)
  final String creditedWalletId;
  @JsonKey(name: MangopayTransactionRequestTags.SecureModeReturnURL)
  final String secureModeReturnURL;
  @JsonKey(name: MangopayTransactionRequestTags.SecureMode)
  final SecureMode secureMode;
  @JsonKey(name: MangopayTransactionRequestTags.CardID)
  final String cardID;
  @JsonKey(name: MangopayTransactionRequestTags.Tag)
  final String tag;
  @JsonKey(name: MangopayTransactionRequestTags.StatementDescriptor)
  final String statementDescriptor;

  MangopayTransactionRequest({
    this.authorId,
    this.debitedFunds,
    this.fees,
    this.creditedWalletId,
    this.secureModeReturnURL,
    this.secureMode,
    this.cardID,
    this.tag,
    this.statementDescriptor,
  });

  Map<String, dynamic> toJson() => _$MangopayTransactionRequestToJson(this);

  factory MangopayTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$MangopayTransactionRequestFromJson(json);

  factory MangopayTransactionRequest.fromData({
    String secureModeReturnURL,
    String creditedWalletId,
    String authorId,
    int amount,
    int fees,
    MangopayCard mangopayCard,
    MangopayRegisterCardData registerCardData,
    SecureMode secureMode = SecureMode.Default,
    String statementDescriptor,
  }) =>
      MangopayTransactionRequest(
        tag: MANGO_PAY_TAG,
        secureModeReturnURL: secureModeReturnURL,
        // cardID: registerCardData.cardId,
        cardID: '103838837',
        creditedWalletId: creditedWalletId,
        authorId: authorId,
        debitedFunds: MangopayMoney(
          currency: mangopayCard.currency,
          amount: amount,
        ),
        fees: MangopayMoney(
          currency: mangopayCard.currency,
          amount: fees,
        ),
        secureMode: secureMode,
        statementDescriptor: statementDescriptor,
      );
}

@JsonSerializable(explicitToJson: true)
class MangopayMoney {
  @JsonKey(name: MangopayMoneyTags.Currency)
  final String currency;
  @JsonKey(name: MangopayMoneyTags.Amount)
  final int amount;

  MangopayMoney({this.currency, this.amount});

  Map<String, dynamic> toJson() => _$MangopayMoneyToJson(this);

  factory MangopayMoney.fromJson(Map<String, dynamic> json) =>
      _$MangopayMoneyFromJson(json);

  @override
  String toString() {
    return 'MangopayMoney{currency: $currency, amount: $amount}';
  }
}
