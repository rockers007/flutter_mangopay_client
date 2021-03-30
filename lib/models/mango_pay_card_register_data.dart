/*{
    "Id": "103507774",
    "Tag": "flutter_mangopay_client",
    "CreationDate": 1615455067,
    "UserId": "85809529",
    "AccessKey": "1X0m87dmM2LiwFgxPLBJ",
    "PreregistrationData": "XBDYiG8w9PrylPS01KmupZVJm3laHBKHSlZGlmhCmp4p-zs-tlU6CGXlVx3voL2f9fwtF16NyLjSBH1cfT6SMg",
    "RegistrationData": null,
    "CardId": null,
    "CardType": "CB_VISA_MASTERCARD",
    "CardRegistrationURL": "https://homologation-webpayment.payline.com/webpayment/getToken",
    "ResultCode": null,
    "ResultMessage": null,
    "Currency": "GBP",
    "Status": "CREATED"
} */

import 'package:json_annotation/json_annotation.dart';

import '../utils.dart';

part 'mango_pay_card_register_data.g.dart';

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
