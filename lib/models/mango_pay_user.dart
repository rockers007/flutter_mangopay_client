import 'package:json_annotation/json_annotation.dart';

import '../utils.dart';

part 'mango_pay_user.g.dart';

/* {
        "PersonType": "NATURAL",
        "Email": "aug_test@yopmail.com",
        "KYCLevel": "LIGHT",
        "Id": "85809440",
        "Tag": null,
        "CreationDate": 1597296764
   } */

/*{
"FirstName": "Joe",
"LastName": "Blogs",
"Birthday": 1463496101,
"Nationality": "GB",
"CountryOfResidence": "FR",
"Email": "support@mangopay.com"
}*/

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
