import 'package:flutter_mangopay_client/flutter_mangopay_client.dart';

import '../models/models.dart';
import 'common_utils.dart';

/// This class contains the utility methods for validating
/// various types of data used & process in mangopay communication.
///
/// Methods in this class are supposed to replicate function of a String validator
/// used in a [TextFormField] or [TextField]
class Validator {
  /// A wrapper method to validate mangopay card data
  static String validateCardDataWithCard(MangopayCard cardData) {
    return validateCardData(
        cardType: cardData.cardType,
        cardCvx: cardData.cvx,
        cardExpirationDate: cardData.expirationDate,
        cardNumber: cardData.cardNumber);
  }

  /// Method that validates the provided card details
  static String validateCardData(
      {String cardNumber = '',
      String cardType = '',
      String cardExpirationDate = '',
      String cardCvx = ''}) {
    // Validate card number
    var isCardValid = cardNumberValidator(cardNumber);
    if (isCardValid != null) return isCardValid;

    // Validate expiration date
    var isDateValid =
        expirationDateValidator(cardExpirationDate, DateTime.now());
    if (isDateValid != null) return isDateValid;

    // Validate card CVx based on card type
    var isCvvValid = cvxValidator(cardCvx, cardType);
    if (isCvvValid != null) return isCvvValid;

    // The data looks good
    return null;
  }

  /// Validator function for cvx values, CVX represents 3 or 4 digit CVV values
  static String cvxValidator(String cvx, String cardType) {
    // These cards don't have cvx values, so verify that the cvx is empty string
    if (cardType == "MAESTRO" || cardType == "BCMC") {
      if (isNotEmpty(cvx)) {
        return 'No CVX value is allowed for $cardType';
      }
      return null;
    }

    cvx = cvx.trim();
    cardType = cardType.trim();

    // CVV is 3 to 4 digits for AMEX cards and 3 digits for all other cards
    if (validateNumericOnly(cvx) == true) {
      if (cardType == "AMEX" && (cvx.length == 3 || cvx.length == 4)) {
        return null;
      }
      if ((cardType == "CBVISAMASTERCARD" ||
              cardType == "CB_VISA_MASTERCARD") &&
          cvx.length == 3) {
        return null;
      }
    }

    // Invalid format
    return 'CVV format is invalid';
  }

  /// Validator function for expiration date of the card
  static String expirationDateValidator(
      String expiryDate, DateTime currentDate) {
    expiryDate = expiryDate.trim();

    // Requires 2 digit for month and 2 digits for year
    if (expiryDate.length == 4) {
      var year = parseInt(expiryDate.substring(2, 4), 10) + 2000;
      var month = parseInt(expiryDate.substring(0, 2), 10);

      if (month > 0 && month <= 12) {
        var currentYear = currentDate.year;
        if (currentYear < year) return null;

        if (currentYear == year) {
          var currentMonth = currentDate.month;
          if (currentMonth <= month) return null;
        }

        // Date is in the past
        return 'Card has expired';
      }
    }

    // Date is not in a recognized
    return 'Expiry format is invalid';
  }

  /// Validator function for Card number
  static String cardNumberValidator(String cardNumber) {
    cardNumber = cardNumber.trim();

    // Check for numbers only
    if (validateNumericOnly(cardNumber) == false) {
      return 'Card number should contain numbers only';
    }

    // Compute and validate check digit
    if (validateCheckDigit(cardNumber) == false) {
      return "Card number is invalid";
    }

    // Number seems ok
    return null;
  }

  /// Validator for a card's number value
  ///
  /// Refer to this for understanding the solution implemented here:
  /// https://stackoverflow.com/questions/12310837/implementation-of-luhn-algorithm
  static bool validateCheckDigit(String cardNumber) {
    var nCheck = 0;
    var bEven = false;
    var value = cardNumber.replaceAll('/\D/g', "");
    for (var n = value.length - 1; n >= 0; n--) {
      var cDigit = String.fromCharCode(value.runes.elementAt(n)),
          nDigit = parseInt(cDigit, 10);
      if (bEven) {
        if ((nDigit *= 2) > 9) nDigit -= 9;
      }
      nCheck += nDigit;
      bEven = !bEven;
    }
    return (nCheck % 10) == 0;
  }

  /// A simple validation function to verify if the provided [id] is
  /// a valid & usable id or not.
  ///
  /// A valid id is supposed to be any [id] with only numeric digits, it can be
  /// of any length but it is not supposed to contain anything else than the numeric
  /// digits
  static bool validateID(String id) {
    return validateNumericOnly(id);
  }

  /// A simple function to validate that the given [sourceData] contains
  /// only numeric digit
  static bool validateNumericOnly(String sourceData) {
    var numbersOnlyRegEx = RegExp(r'^[0-9]+$');
    return numbersOnlyRegEx.hasMatch(sourceData);
  }

  /// A Simple wrapper method to easily parse a [number] value with provided [radix]
  ///
  /// result is an integer value
  static int parseInt(String number, int radix) {
    return int.parse(number, radix: radix);
  }

  /// A Simple wrapper method to easily parse a [number] value
  ///
  /// result is a double value
  static double parseDouble(String number) {
    return double.parse(number);
  }

  /// A Simple wrapper method to easily parse a [number] value
  ///
  /// result is an num object which might be an [int] or [double]
  static num parseNum(String number) {
    return num.parse(number);
  }
}
