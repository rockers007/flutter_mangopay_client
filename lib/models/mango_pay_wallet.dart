import 'package:json_annotation/json_annotation.dart';

import '../mangopay_client.dart';
import '../utils.dart';

part 'mango_pay_wallet.g.dart';

/*{
    "Description": "GBP wallet",
    "Owners": [ "103005702" ],
    "Balance": { "Currency": "GBP", "Amount": 0 },
    "Currency": "GBP",
    "FundsType": "DEFAULT",
    "Id": "103615963",
    "Tag": "flutter_mangopay_client",
    "CreationDate": 1615548840
}*/

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
