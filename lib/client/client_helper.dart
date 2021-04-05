import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/common_utils.dart';
import '../utils/resources.dart';

/// --- Getters for api suffixes --- ///
String getUsersSuffix() => '/users';

String getCardSuffix(String userID) => '/users/$userID/cards/';

String getRegisterCardSuffix() => '/cardregistrations';

String getCompleteRegisterCardSuffix(String id) => '/cardregistrations/$id';

String getDeactivateCardSuffix(String cardID) => '/cards/$cardID';

String getCreateWalletSuffix() => '/wallets';

String getRegisterUserSuffix() => '/users/natural';

String getDirectPayinSuffix() => '/payins/card/direct';

/// --- Utility functions --- ///

/// Get Authentication token string for authorization
String getAuthToken(String clientID, String clientPassword) {
  return 'Basic ${stringToBase64('$clientID:$clientPassword')}';
}

/// Get authorization headers for mangopay api communications
Map<String, String> getMangopayHeader(
  String clientID,
  String clientPassword,
) {
  final token = getAuthToken(clientID, clientPassword);
  return {'Authorization': token};
}

/// Append json specific headers in the provided [headerData]
///
/// Since the collection is a [Map], this process may overwrite previous
/// headers
Map<String, dynamic> appendJSONHeaders(Map<String, dynamic> headerData) {
  headerData.addAll(getJSONHeaders());
  return headerData;
}

/// Append url-form specific headers in the provided [headerData]
///
/// Since the collection is a [Map], this process may overwrite previous
/// headers
Map<String, dynamic> appendFormHeader(Map<String, dynamic> headerData) {
  headerData.addAll(getFormHeaders());
  return headerData;
}

/// This method is used for providing a map containing the header
/// values for a json request
Map<String, String> getJSONHeaders() {
  final map = <String, String>{
    // HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  return map;
}

/// This method is used for providing a map containing the header
/// values for a form url encoded request
Map<String, String> getFormHeaders() {
  final map = <String, String>{
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
  };
  return map;
}

/// This method is used to send an HTTP POST request
/// with given [url]. The response will be
/// provided as a string, whether it is a plain text or a json response.
///
/// This method will execute a network request with request type
/// based on the provided [isPost] and [isJsonRequest] flags.
///
///
/// Note: If one of the above described flag is set to true then
/// the request will be sent as an 'Http Post' request.
///
/// For ex. if isPost=false but isJsonRequest=true
///  then what is asked is an 'Http Get' request with json parameters,
///   but in Get request the body parameter is not allowed. so all the parameters
///   must be included in the url for them to work.
///
/// To handle this scenario, this method will send request to given
/// url as an 'Http Post' request if it is declared as post request
/// or if declared as a json request
Future<String> getDataFromNetwork({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  bool isPost = false,
  bool isJsonRequest = false,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
}) async {
  assert(isNotEmpty(url), 'URL can not be empty or null!!');

  //check if request is to be sent as a json request
  if (isJsonRequest) {
    if (isNotEmpty(headerData)) {
      headerData = appendJSONHeaders(headerData);
    } else {
      headerData = getJSONHeaders();
    }
  }

  http.Response response;
  if (isPost || isJsonRequest) {
    response = await executePostRequest(
      url,
      headerData: headerData,
      parameters: parameters,
      timeOut: timeOut,
      onTimeOut: onTimeOut,
      onError: onError,
    );
  } else {
    response = await executeGetRequest(
      url,
      headerData: headerData,
      timeOut: timeOut,
      onTimeOut: onTimeOut,
      onError: onError,
    );
  }

  if (response == null) {
    return null;
  }
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return response.body;
  }
}

/// This method will execute an HTTP Get request
///
/// Note: additional parameters must be included in the URL before
/// sending request
Future<http.Response> executeGetRequest(
  String url, {
  Map<String, String> headerData,
  Duration timeOut = const Duration(seconds: 60),
  void Function() onTimeOut,
  Function(dynamic) onError,
}) {
  // print('executeGetRequest: url: $url');
  // print('executeGetRequest: header: $headerData');

  return http
      .get(
        url.trim(),
        headers: headerData,
      )
      .timeout(timeOut)
      .catchError((dynamic error) {
    if (error is TimeoutException) {
      onTimeOut?.call();
    } else {
      onError?.call(error);
    }
  });
}

/// This method will execute an HTTP Post request
Future<http.Response> executePostRequest(
  String url, {
  Map<String, String> headerData,
  dynamic parameters,
  Duration timeOut = const Duration(seconds: 60),
  void Function() onTimeOut,
  Function(dynamic) onError,
}) {
  // print('executePostRequest: url: $url');
  // print('executePostRequest: header: $headerData');
  // print('executePostRequest: parameter: $parameters');
  return http
      .post(
        url.trim(),
        headers: headerData,
        body: parameters,
      )
      .timeout(timeOut)
      .catchError((dynamic error) {
    if (error is TimeoutException) {
      onTimeOut?.call();
    } else {
      onError?.call(error);
    }
  });
}

/// Method to check if the connection is live or not
Future<bool> isConnectionLive(String url, {bool isPost = false}) async {
  var connectionStatus = false;
  try {
    http.Response response;
    if (isPost) {
      response = await executePostRequest(url);
    } else {
      response = await executeGetRequest(url);
    }
    connectionStatus = response.statusCode == HttpStatus.ok;
  } catch (e, s) {
    print('isConnectionLive() : $e \n$s');
  }
  return connectionStatus;
}

String convertJsonToNormal(Map<String, dynamic> json) {
  StringBuffer buffer = StringBuffer();

  json.keys.forEach((key) {
    buffer.write('&');
    buffer.write('$key=${json[key]}');
  });

  final params = buffer.toString().substring(1);
  return params;
}

Future<String> fetchRawDataFromPost({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
  bool isJsonRequest = true,
}) async {
  // print('fetchRawDataFromPost: url: ${BASE_API + urlSuffix}');
  // print('fetchRawDataFromPost: header: $headerData');
  // print('fetchRawDataFromPost: parameter: $parameters');

  final responseString = await getDataFromNetwork(
    url: url,
    parameters: parameters,
    headerData: headerData,
    timeOut: timeOut,
    onTimeOut: onTimeOut,
    onError: onError,
    isJsonRequest: isJsonRequest,
    isPost: true,
  );
  if (isNotEmpty(responseString)) {
    return responseString;
  }
  return null;
}

Future<T> fetchDataFromPostRequest<T>({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
  bool isJsonRequest = true,
}) async {
  print('getDataFromNetwork: url: $url}');
  print('getDataFromNetwork: header: $headerData');
  print('getDataFromNetwork: parameter: $parameters');

  final responseString = await fetchRawDataFromPost(
    url: url,
    parameters: parameters,
    headerData: headerData,
    timeOut: timeOut,
    onTimeOut: onTimeOut,
    onError: onError,
    isJsonRequest: isJsonRequest,
  );

  print('responseString: $responseString');
  if (isNotEmpty(responseString)) {
    final json = jsonDecode(responseString) as T;
    return json;
  }
  return null;
}

Future<String> fetchRawDataFromGet({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
}) async {
  // print('getDataFromNetwork: url: ${BASE_API + urlSuffix}');
  // print('getDataFromNetwork: header: $headerData');
  // print('getDataFromNetwork: parameter: $parameters');

  final responseString = await getDataFromNetwork(
    url: url,
    parameters: parameters,
    headerData: headerData,
    timeOut: timeOut,
    onTimeOut: onTimeOut,
    onError: onError,
    isJsonRequest: false,
  );
  if (isNotEmpty(responseString)) {
    return responseString;
  }
  return null;
}

Future<T> fetchDataFromGetRequest<T>({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
}) async {
  // print('getDataFromNetwork: url: ${BASE_API + urlSuffix}');
  // print('getDataFromNetwork: header: $headerData');
  // print('getDataFromNetwork: parameter: $parameters');

  final responseString = await fetchRawDataFromGet(
    url: url,
    parameters: parameters,
    headerData: headerData,
    timeOut: timeOut,
    onTimeOut: onTimeOut,
    onError: onError,
  );
  if (isNotEmpty(responseString)) {
    final json = jsonDecode(responseString) as T;
    // print('response: $json');
    return json;
  }
  return null;
}

/// PUT request

Future<T> putDataWithFormattedResponse<T>({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
  bool isJsonRequest = false,
}) async {
  // print('putDataWithFormattedResponse: url: ${BASE_API + urlSuffix}');
  // print('putDataWithFormattedResponse: header: $headerData');
  // print('putDataWithFormattedResponse: parameter: $parameters');

  final responseString = await putDataWithRawResponse(
    url: url,
    parameters: parameters,
    headerData: headerData,
    timeOut: timeOut,
    onTimeOut: onTimeOut,
    onError: onError,
    isJsonRequest: isJsonRequest,
  );
  if (isNotEmpty(responseString)) {
    final json = jsonDecode(responseString) as T;
    // print('response: $json');
    return json;
  }
  return null;
}

Future<String> putDataWithRawResponse({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
  bool isJsonRequest = false,
}) async {
  // print('putDataWithRawResponse: url: ${BASE_API + urlSuffix}');
  // print('putDataWithRawResponse: header: $headerData');
  // print('putDataWithRawResponse: parameter: $parameters');

  final responseString = await putData(
    url: url,
    parameters: parameters,
    headerData: headerData,
    timeOut: timeOut,
    onTimeOut: onTimeOut,
    onError: onError,
    isJsonRequest: isJsonRequest,
  );
  if (isNotEmpty(responseString)) {
    return responseString;
  }
  return null;
}

Future<String> putData({
  @required String url,
  dynamic parameters,
  Map<String, String> headerData,
  bool isPost = false,
  bool isJsonRequest = false,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
}) async {
  assert(isNotEmpty(url), 'URL can not be empty or null!!');

  // final isLive = await isConnectionLive(BASE_API);
  // assert(isLive, 'Api connection is not live');

  //check if request is to be sent as a json request
  if (isJsonRequest) {
    if (isNotEmpty(headerData)) {
      headerData = appendJSONHeaders(headerData);
    } else {
      headerData = getJSONHeaders();
    }
  }

  http.Response response = await executePutRequest(
    url,
    headerData: headerData,
    parameters: parameters,
    timeOut: timeOut,
    onTimeOut: onTimeOut,
    onError: onError,
  );

  if (response == null) {
    return null;
  }
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return response.body;
  }
}

/// This method will execute an HTTP Put request
Future<http.Response> executePutRequest(
  String url, {
  Map<String, String> headerData,
  dynamic parameters,
  Duration timeOut = const Duration(seconds: 60),
  void Function() onTimeOut,
  Function(dynamic) onError,
}) {
  // print('executePutRequest: url: $url');
  // print('executePutRequest: header: $headerData');
  // print('executePutRequest: parameter: $parameters');
  return http
      .put(
        url.trim(),
        headers: headerData,
        body: parameters,
      )
      .timeout(timeOut)
      .catchError((dynamic error) {
    if (error is TimeoutException) {
      onTimeOut?.call();
    } else {
      onError?.call(error);
    }
  });
}
