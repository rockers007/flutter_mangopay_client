import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';

part 'mangopay_transaction_request.g.dart';

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

/// The model class that represents a collection of data used for posting the card's
/// data for registration.
///
/// Please refer to Mangopay documentation:
/// https://docs.mangopay.com/endpoints/v2.01/cards#e1042_post-card-info
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
    String cardId,
    String currency,
    SecureMode secureMode = SecureMode.Default,
    String statementDescriptor,
    String tag = MANGOPAY_TAG,
  }) =>
      MangopayTransactionRequest(
        tag: tag,
        secureModeReturnURL: secureModeReturnURL,
        cardID: cardId,
        creditedWalletId: creditedWalletId,
        authorId: authorId,
        debitedFunds: MangopayMoney(
          currency: currency,
          amount: amount,
        ),
        fees: MangopayMoney(
          currency: currency,
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
