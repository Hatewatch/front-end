
import 'dart:convert';

import 'package:hate_watch/api/json.dart';
import 'package:hate_watch/class/user.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getCallHw(String page,  {String action = "", List<String> listArgs = const [], bool testPrints = false}) async {
  return getCallApi(page, action, listArgs, testPrints: testPrints);
}

Future<dynamic> getCallApi(String phpPage, String action, List<String> listArgs, {bool testPrints = false}) async {
  String args = '';
  for (var arg in listArgs) {
    args += '&$arg';
  }

  if (testPrints) print("ARGS : $args");
  
  var headers = {
    'Authorization': "Bearer ${User.instance.token}",
  };
  var request = http.Request(
      'GET', Uri.parse('https://riftbets-backend.onrender.com/$phpPage$action$args'));

  request.headers.addAll(headers);

  if (testPrints) print("Request : $request");
  if (testPrints) print("Headers : $headers");
  

  http.StreamedResponse response = await request.send();

  if (testPrints) {
    if (response.statusCode == 401) {
      print("GET CALL API STATUS CODE : 401");
      print( await response.stream.bytesToString());
    }
    print(response.reasonPhrase);
  }

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    
    if (await isJsonDecodable(responseBody)) {
      var jsonData = await jsonDecode(responseBody);
      if (testPrints) print("END GET CALL API : $jsonData");
      return jsonData;
    } else {
      if (testPrints) print("END GET CALL API : $responseBody");
      return responseBody;
    }
  } else {
    if (testPrints) print("END GET CALL API Error : ${response.reasonPhrase} : ${response.statusCode}");
    return null;
  }
}

Future postCallApi(String phpPage, List<String> listArgs) async {
  String args = '';
  for (var arg in listArgs) {
    args += '&$arg';
  }
  
  var headers = {
    'Authorization': "Bearer ${User.instance.token}",
  };

  // print(listArgs);

  var request = http.Request(
      'POST', Uri.parse('https://riftbets-backend.onrender.com/$phpPage$args'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print("response : ${response.statusCode}");
    print(await response.stream.bytesToString());
    var responseBody = await response.stream.bytesToString();
    return responseBody;
  } else {
    print("reason : ${response.reasonPhrase}");
  }
}

Future postCallApiBody(String phpPage, Map<String, dynamic> listArgs) async {
  String jsonBody = jsonEncode(listArgs);

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': "Bearer ${User.instance.token}",
  };


  var request =
      http.Request('POST', Uri.parse('https://riftbets-backend.onrender.com/$phpPage'));

  request.headers.addAll(headers);
  request.body = jsonBody;

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();

    if (await isJsonDecodable(responseBody)) {
      var jsonData = await jsonDecode(responseBody);
      return jsonData;
    } else {
      return responseBody;
    }
  } else {
    var responseBody = await response.stream.bytesToString();
    if (await isJsonDecodable(responseBody)) {
      var jsonData = await jsonDecode(responseBody);
      return jsonData;
    } else {
      return responseBody;
    }
    // print("reason : ${response.reasonPhrase}");
  }
}