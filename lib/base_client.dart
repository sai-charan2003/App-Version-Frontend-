import 'dart:convert';

import 'package:app_version_api/components/data.dart';
import 'package:app_version_api/user.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://127.0.0.1:9080";

class BaseClient {
  var client = http.Client();

  Future<dynamic> post(String api) async {

  }

Future<dynamic> registerUser(dynamic object) async {
  var url = Uri.parse(baseUrl + "/register");
  
  var _payload = jsonEncode(object);
  
  var response = await client.post(
    url,
    body: _payload,
    headers: {
      "Content-Type": "application/json",
    },
  );
  print(response);

  if(response.statusCode == 201){ 

  var jsonResponse = jsonDecode(response.body);

  var user = User.fromJson(jsonResponse);
  print(user);
  return user;
  }

  else if(response.statusCode == 409){
      return response.statusCode;
  } 
  else {
  return response.body; 
  } 
}


  

Future<dynamic> loginUser(dynamic object) async {
  var url = Uri.parse(baseUrl + "/login");
  
  var _payload = jsonEncode(object);
  
  var response = await client.post(
    url,
    body: _payload,
    headers: {
      "Content-Type": "application/json",
    },
  );

  var jsonResponse = jsonDecode(response.body);

  var user = User.fromJson(jsonResponse);
  print(response);

  if(response.statusCode == 200){ 

  var jsonResponse = jsonDecode(response.body);

  var user = User.fromJson(jsonResponse);
  print(user);
  return user;
  }

  else if(response.statusCode == 409){
      return response.statusCode;
  } 
  else {
  return response.body; 
  } 
 
}

Future<List<Data>> getData(String apiKey) async {
  var url = Uri.parse('$baseUrl/getData?apiKey=$apiKey');
  var response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    print(response.body);   
    List<Data> dataList = dataFromJson(response.body);
    print(dataList.first.appName);
    return dataList;
  } else if (response.statusCode == 409) {
    throw Exception('Conflict: ${response.statusCode}');
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
}


}