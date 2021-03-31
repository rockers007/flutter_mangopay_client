import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';

part 'mangopay_user.g.dart';

/// This model class represents a mangopay user instance.
///
/// Please refer to Mangopay documentation:
/// https://docs.mangopay.com/endpoints/v2.01/users#e253_the-user-object
@JsonSerializable(explicitToJson: true)
class MangopayUser {
  @JsonKey(name: UserTags.PersonType)
  final String personType;
  @JsonKey(name: UserTags.Email)
  final String email;
  @JsonKey(name: UserTags.KYCLevel)
  final String kycLevel;
  @JsonKey(name: UserTags.ID)
  final String id;
  @JsonKey(name: UserTags.Tag)
  final String tag;
  @JsonKey(name: UserTags.CreationDate)
  final double creationDateInMills;

  MangopayUser({
    this.personType,
    this.email,
    this.kycLevel,
    this.id,
    this.tag,
    this.creationDateInMills,
  });

  Map<String, dynamic> toJson() => _$MangopayUserToJson(this);

  factory MangopayUser.fromJson(Map<String, dynamic> json) =>
      _$MangopayUserFromJson(json);

  @override
  String toString() {
    return 'MangopayUser{personType: $personType, email: $email, kycLevel: $kycLevel, id: $id, tag: $tag, creationDateInMills: $creationDateInMills}';
  }
}
