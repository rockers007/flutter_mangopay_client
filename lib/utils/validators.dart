import '../models/models.dart';

class Validator {
  static String validateCardDataWithCard(MangopayCard cardData) {
    return validateCardData(
        cardType: cardData.cardType,
        cardCvx: cardData.cvx,
        cardExpirationDate: cardData.expirationDate,
        cardNumber: cardData.cardNumber);
  }

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
    var isCvvValid = cvvValidator(cardCvx, cardType);
    if (isCvvValid != null) return isCvvValid;

    // The data looks good
    return null;
  }

  static String cvvValidator(String cvv, String cardType) {
    if (cardType == "MAESTRO" || cardType == "BCMC") {
      return null;
    }
    cvv = cvv.trim();
    cardType = cardType.trim();

    // CVV is 3 to 4 digits for AMEX cards and 3 digits for all other cards
    if (validateNumericOnly(cvv) == true) {
      if (cardType == "AMEX" && (cvv.length == 3 || cvv.length == 4)) {
        return null;
      }
      if ((cardType == "CBVISAMASTERCARD" ||
              cardType == "CB_VISA_MASTERCARD") &&
          cvv.length == 3) {
        return null;
      }
    }

    // Invalid format
    return 'CVV format is invalid';
  }

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

    // Date does not look correct
    return 'Expiry format is invalid';
  }

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

  static bool validateCheckDigit(String cardNumber) {
    // From https://stackoverflow.com/questions/12310837/implementation-of-luhn-algorithm
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

  static bool validateIDs(String id) {
    var numbersOnlyRegEx = RegExp(r'^[0-9]+$');
    return numbersOnlyRegEx.hasMatch(id);
  }

  static bool validateNumericOnly(String cardNumber) {
    var numbersOnlyRegEx = RegExp(r'^[0-9]+$');
    return numbersOnlyRegEx.hasMatch(cardNumber);
  }

  static int parseInt(String number, int radix) {
    return int.parse(number, radix: radix);
  }
}
