import 'dart:convert';

import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/data.dart';
import 'package:app_version_api/user.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://version-tracker.onrender.com";

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

  // Print the response status and body for debugging
  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) { 
    // Parse JSON response if the status code is 200 (OK)
    var jsonResponse = jsonDecode(response.body);
    var user = User.fromJson(jsonResponse);
    return user;
  } else if (response.statusCode == 409) {
    // Conflict error, return the status code or specific error message
    return response.statusCode;
  } else {
    // Return the plain text response body or a custom error message
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

  print(response.statusCode);

  if (response.statusCode == 200 ||response.statusCode == 201 ) {    
    if(response.body.isEmpty){
      return List.empty();
    }
    List<Data> dataList = dataFromJson(response.body);
    print(dataList.first.appName);
    dataList.sort((a, b) {

  if (a.appName == null && b.appName == null) {
    return 0; 
  } else if (a.appName == null) {
    return -1; 
  } else if (b.appName == null) {
    return 1; 
  } else {
    return a.appName!.compareTo(b.appName!); // Compare non-null values
  }
});

    return dataList;
  } else if (response.statusCode == 404) {
    return List.empty();
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
}

Future<Map<String, String>> saveData(dynamic object) async {
  print("Object:");
  print(object);

  // Ensure that the API key and JWT token are fetched correctly
  String? apiKey = await SharedPreferencesHelper.getAPIKEY();
  String? jwtToken = await SharedPreferencesHelper.getJwtToken();

  if (apiKey == null || jwtToken == null) {
    print("API key or JWT token is null");
    return {"success": "false", "message": "Error Occurred, Please Re-Login Again"};
  }

  var url = Uri.parse('$baseUrl/appData/postAppDetails?apiKey=$apiKey');

  var _payload = jsonEncode(object);
  print("Payload:");
  print(_payload);

  try {
    var response = await http.post(
      url,
      body: _payload,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      },
    );

    print("Status Code: ${response.statusCode}");
    print(response.body);

    if (response.statusCode == 200||response.statusCode == 201) {
      // Assuming your response body is a JSON object
      var jsonResponse = jsonDecode(response.body);
      var data = Data.fromJson(jsonResponse);
      print("Response Data:");
      print(data);

      return {"success": "true", "message": "Data Saved"};
    } else if (response.statusCode == 409) {
      return {"success": "false", "message": response.body};
    } else {
      print("Request failed with status: ${response.statusCode}");
      return {"success": "false", "message": response.body};
    }
  } catch (e) {
    print("Error occurred: $e");
    return {"success": "false", "message": e.toString()};
  }
}
Future<Map<String,String>> patchData(dynamic object) async {
  print("Object:");
  print(object);

  String? apiKey = await SharedPreferencesHelper.getAPIKEY();
  String? jwtToken = await SharedPreferencesHelper.getJwtToken();

  if (apiKey == null || jwtToken == null) {
    print("API key or JWT token is null");
    return {"success": "false", "message": "Error Occurred, Please Re-Login Again"};
  }

  var url = Uri.parse('$baseUrl/appData/updateAppDetails?apiKey=$apiKey');

  var _payload = jsonEncode(object);
  print("Payload:");
  print(_payload);

  try {
    var response = await http.patch(
      url,
      body: _payload,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      },
    );

    print("Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {      
      return {"success": "true", "message": "Data Saved"};

    } else if (response.statusCode == 409) {
     return {"success": "false", "message": response.body};
    } else {
      print("Request failed with status: ${response.statusCode}");
      return {"success": "false", "message": response.body};
    }
  } catch (e) {
    print("Error occurred: $e");
    return {"success": "false", "message": e.toString()};
  }
}
Future<bool> deleteData(String uuid) async {

  String? apiKey = await SharedPreferencesHelper.getAPIKEY();
  String? jwtToken = await SharedPreferencesHelper.getJwtToken();

  if (apiKey == null || jwtToken == null) {
    print("API key or JWT token is null");
    return false;
  }

  var url = Uri.parse('$baseUrl/appData/deleteAppDetails?appUUID=$uuid');


  try {
    var response = await http.delete(
      url,      
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      },
    );

    print("Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {      
      var jsonResponse = jsonDecode(response.body);
      var data = Data.fromJson(jsonResponse);
      print("Response Data:");
      print(data);

      return true;
    } else if (response.statusCode == 409) {
      return false;
    } else {
      print("Request failed with status: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error occurred: $e");
    return false;
  }
}
}

