import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';
import 'models.dart';

part 'mangopay_wallet.g.dart';

/// This model class represents a mangopay wallet
///
/// Please refer to Mangopay documentation:
/// https://docs.mangopay.com/endpoints/v2.01/wallets#e20_the-wallet-object
@JsonSerializable(explicitToJson: true)
class Wallet {
  @JsonKey(name: WalletTags.Description)
  final String description;
  @JsonKey(name: WalletTags.Owners)
  final List<String> owners;
  @JsonKey(name: WalletTags.Balance)
  final MangopayMoney balance;
  @JsonKey(name: WalletTags.Currency)
  final String currency;
  @JsonKey(name: WalletTags.FundsType)
  final String fundsType;
  @JsonKey(name: WalletTags.Id)
  final String id;
  @JsonKey(name: WalletTags.Tag)
  final String tag;
  @JsonKey(name: WalletTags.CreationDate)
  final int creationDateInMills;

  Wallet(
      {this.description,
      this.owners,
      this.balance,
      this.currency,
      this.fundsType,
      this.id,
      this.tag,
      this.creationDateInMills});

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  @override
  String toString() {
    return 'Wallet{description: $description, owners: $owners, balance: $balance, currency: $currency, fundsType: $fundsType, id: $id, tag: $tag, creationDate: $creationDateInMills}';
  }
}
