import 'dart:convert';

/// Method is an extension to check if the provided
/// [data] is null or empty
bool isEmpty(dynamic data) {
  if (data is Iterable || data is Map || data is String) {
    return data?.isEmpty ?? true;
  } else {
    return data == null;
  }
}

/// Method is an extension to check if the provided
/// [data] is not null and empty
bool isNotEmpty(dynamic data) {
  return !isEmpty(data);
}

/// Method to convert a simple string to base64 string
String stringToBase64(String data) {
  return base64.encode(utf8.encode(data));
}
