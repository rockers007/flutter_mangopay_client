import 'package:fluttertoast/fluttertoast.dart';

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

void showToast(String message) {
  Fluttertoast.showToast(msg: message);
}
