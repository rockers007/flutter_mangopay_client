// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mangopay_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangopayWallet _$WalletFromJson(Map<String, dynamic> json) {
  return MangopayWallet(
    description: json['Description'] as String,
    owners: (json['Owners'] as List)?.map((e) => e as String)?.toList(),
    balance: json['Balance'] == null
        ? null
        : MangopayMoney.fromJson(json['Balance'] as Map<String, dynamic>),
    currency: json['Currency'] as String,
    fundsType: json['FundsType'] as String,
    id: json['Id'] as String,
    tag: json['Tag'] as String,
    creationDateInMills: json['CreationDate'] as int,
  );
}

Map<String, dynamic> _$WalletToJson(MangopayWallet instance) =>
    <String, dynamic>{
      'Description': instance.description,
      'Owners': instance.owners,
      'Balance': instance.balance?.toJson(),
      'Currency': instance.currency,
      'FundsType': instance.fundsType,
      'Id': instance.id,
      'Tag': instance.tag,
      'CreationDate': instance.creationDateInMills,
    };
