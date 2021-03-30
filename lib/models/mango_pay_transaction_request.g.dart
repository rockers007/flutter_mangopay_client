// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mango_pay_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangopayTransactionRequest _$MangopayTransactionRequestFromJson(
    Map<String, dynamic> json) {
  return MangopayTransactionRequest(
    authorId: json['AuthorId'] as String,
    debitedFunds: json['DebitedFunds'] == null
        ? null
        : MangopayMoney.fromJson(json['DebitedFunds'] as Map<String, dynamic>),
    fees: json['Fees'] == null
        ? null
        : MangopayMoney.fromJson(json['Fees'] as Map<String, dynamic>),
    creditedWalletId: json['CreditedWalletId'] as String,
    secureModeReturnURL: json['SecureModeReturnURL'] as String,
    secureMode: _$enumDecodeNullable(_$SecureModeEnumMap, json['SecureMode']),
    cardID: json['CardID'] as String,
    tag: json['Tag'] as String,
    statementDescriptor: json['StatementDescriptor'] as String,
  );
}

Map<String, dynamic> _$MangopayTransactionRequestToJson(
        MangopayTransactionRequest instance) =>
    <String, dynamic>{
      'AuthorId': instance.authorId,
      'DebitedFunds': instance.debitedFunds?.toJson(),
      'Fees': instance.fees?.toJson(),
      'CreditedWalletId': instance.creditedWalletId,
      'SecureModeReturnURL': instance.secureModeReturnURL,
      'SecureMode': _$SecureModeEnumMap[instance.secureMode],
      'CardID': instance.cardID,
      'Tag': instance.tag,
      'StatementDescriptor': instance.statementDescriptor,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SecureModeEnumMap = {
  SecureMode.Default: 'DEFAULT',
  SecureMode.NoChoice: 'NO_CHOICE',
  SecureMode.Force: 'FORCE',
};

MangopayMoney _$MangopayMoneyFromJson(Map<String, dynamic> json) {
  return MangopayMoney(
    currency: json['Currency'] as String,
    amount: json['Amount'] as int,
  );
}

Map<String, dynamic> _$MangopayMoneyToJson(MangopayMoney instance) =>
    <String, dynamic>{
      'Currency': instance.currency,
      'Amount': instance.amount,
    };
