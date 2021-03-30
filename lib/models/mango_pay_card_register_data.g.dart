// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mango_pay_card_register_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangopayRegisterCardData _$MangopayRegisterCardDataFromJson(
    Map<String, dynamic> json) {
  return MangopayRegisterCardData(
    id: json['Id'] as String,
    tag: json['Tag'] as String,
    creationDate: (json['CreationDate'] as num)?.toDouble(),
    userID: json['UserId'] as String,
    accessKey: json['AccessKey'] as String,
    preregistrationData: json['PreregistrationData'] as String,
    registrationData: json['RegistrationData'] as String,
    cardId: json['CardId'] as String,
    cardType: json['CardType'] as String,
    cardRegistrationURL: json['CardRegistrationURL'] as String,
    resultCode: json['ResultCode'] as String,
    resultMessage: json['ResultMessage'] as String,
    currency: json['Currency'] as String,
    status: json['Status'] as String,
  );
}

Map<String, dynamic> _$MangopayRegisterCardDataToJson(
        MangopayRegisterCardData instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Tag': instance.tag,
      'CreationDate': instance.creationDate,
      'UserId': instance.userID,
      'AccessKey': instance.accessKey,
      'PreregistrationData': instance.preregistrationData,
      'RegistrationData': instance.registrationData,
      'CardId': instance.cardId,
      'CardType': instance.cardType,
      'CardRegistrationURL': instance.cardRegistrationURL,
      'ResultCode': instance.resultCode,
      'ResultMessage': instance.resultMessage,
      'Currency': instance.currency,
      'Status': instance.status,
    };
