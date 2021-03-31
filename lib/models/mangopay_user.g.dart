// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mangopay_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangopayUser _$MangopayUserFromJson(Map<String, dynamic> json) {
  return MangopayUser(
    personType: json['PersonType'] as String,
    email: json['Email'] as String,
    kycLevel: json['KYCLevel'] as String,
    id: json['Id'] as String,
    tag: json['Tag'] as String,
    creationDateInMills: (json['CreationDate'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$MangopayUserToJson(MangopayUser instance) =>
    <String, dynamic>{
      'PersonType': instance.personType,
      'Email': instance.email,
      'KYCLevel': instance.kycLevel,
      'Id': instance.id,
      'Tag': instance.tag,
      'CreationDate': instance.creationDateInMills,
    };
