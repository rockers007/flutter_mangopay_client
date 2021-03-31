import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';

part 'mangopay_card_register_data.g.dart';

/// The model class that represents a collection of registration data
/// used for card registration process.
///
/// Most of these fields are the supposed to be used in the intermediate process
/// for card registration.
///
/// Note: None of these fields are to be used directly outside the mangopay
/// communication except maybe [cardId] which also is available when card details
/// are fetched from the mangopay api for a client.
///
/// Please refer to Mangopay documentation:
///  - https://docs.mangopay.com/endpoints/v2.01/cards#e177_the-card-registration-object
///  - https://docs.mangopay.com/endpoints/v2.01/cards#e178_create-a-card-registration
///  - https://docs.mangopay.com/endpoints/v2.01/cards#e179_update-a-card-registration
@JsonSerializable(explicitToJson: true)
class MangopayRegisterCardData {
  @JsonKey(name: MangopayRegisterCardDataTags.Id)
  final String id;
  @JsonKey(name: MangopayRegisterCardDataTags.Tag)
  final String tag;
  @JsonKey(name: MangopayRegisterCardDataTags.CreationDate)
  final double creationDate;
  @JsonKey(name: MangopayRegisterCardDataTags.UserId)
  final String userID;
  @JsonKey(name: MangopayRegisterCardDataTags.AccessKey)
  final String accessKey;
  @JsonKey(name: MangopayRegisterCardDataTags.PreregistrationData)
  final String preregistrationData;
  @JsonKey(name: MangopayRegisterCardDataTags.RegistrationData)
  final String registrationData;
  @JsonKey(name: MangopayRegisterCardDataTags.CardId)
  final String cardId;
  @JsonKey(name: MangopayRegisterCardDataTags.CardType)
  final String cardType;
  @JsonKey(name: MangopayRegisterCardDataTags.CardRegistrationURL)
  final String cardRegistrationURL;
  @JsonKey(name: MangopayRegisterCardDataTags.ResultCode)
  final String resultCode;
  @JsonKey(name: MangopayRegisterCardDataTags.ResultMessage)
  final String resultMessage;
  @JsonKey(name: MangopayRegisterCardDataTags.Currency)
  final String currency;
  @JsonKey(name: MangopayRegisterCardDataTags.Status)
  final String status;

  MangopayRegisterCardData(
      {this.id,
      this.tag,
      this.creationDate,
      this.userID,
      this.accessKey,
      this.preregistrationData,
      this.registrationData,
      this.cardId,
      this.cardType,
      this.cardRegistrationURL,
      this.resultCode,
      this.resultMessage,
      this.currency,
      this.status});

  bool get hasData {
    return isNotEmpty(id) &&
        isNotEmpty(tag) &&
        isNotEmpty(creationDate) &&
        isNotEmpty(userID) &&
        isNotEmpty(accessKey) &&
        isNotEmpty(preregistrationData) &&
        isNotEmpty(cardType) &&
        isNotEmpty(cardRegistrationURL) &&
        isNotEmpty(currency) &&
        isNotEmpty(status);
  }

  Map<String, dynamic> toJson() => _$MangopayRegisterCardDataToJson(this);

  factory MangopayRegisterCardData.fromJson(Map<String, dynamic> json) =>
      _$MangopayRegisterCardDataFromJson(json);

  @override
  String toString() {
    return 'MangopayRegisterCardData{id: $id, tag: $tag, creationDate: $creationDate, userID: $userID, accessKey: $accessKey, preregistrationData: $preregistrationData, registrationData: $registrationData, cardId: $cardId, cardType: $cardType, cardRegistrationURL: $cardRegistrationURL, resultCode: $resultCode, resultMessage: $resultMessage, currency: $currency, status: $status}';
  }
}
