// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mango_pay_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangopayCard _$MangopayCardFromJson(Map<String, dynamic> json) {
  return MangopayCard(
    expirationDate: json['ExpirationDate'] as String,
    alias: json['Alias'] as String,
    cardType: json['CardType'] as String,
    cardProvider: json['CardProvider'] as String,
    country: json['Country'] as String,
    product: json['Product'] as String,
    bankCode: json['BankCode'] as String,
    active: json['Active'] as bool,
    currency: json['Currency'] as String,
    validity: json['Validity'] as String,
    userID: json['UserId'] as String,
    id: json['Id'] as String,
    tag: json['Tag'] as String,
    creationDateInMills: (json['CreationDate'] as num)?.toDouble(),
    fingerprint: json['Fingerprint'] as String,
    cardNumber: json['cardNumber'] as String,
    cvx: json['cvx'] as String,
  );
}

Map<String, dynamic> _$MangopayCardToJson(MangopayCard instance) =>
    <String, dynamic>{
      'ExpirationDate': instance.expirationDate,
      'Alias': instance.alias,
      'CardType': instance.cardType,
      'CardProvider': instance.cardProvider,
      'Country': instance.country,
      'Product': instance.product,
      'BankCode': instance.bankCode,
      'Active': instance.active,
      'Currency': instance.currency,
      'Validity': instance.validity,
      'UserId': instance.userID,
      'Id': instance.id,
      'Tag': instance.tag,
      'CreationDate': instance.creationDateInMills,
      'Fingerprint': instance.fingerprint,
      'cvx': instance.cvx,
      'cardNumber': instance.cardNumber,
    };
