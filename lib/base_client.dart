import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://127.0.0.1:8080";

class BaseClient {
  var client = http.Client();

  Future<dynamic> post(String api) async {

  }

  Future<dynamic> registerUser(dynamic object) async{
    
    var url = Uri.parse("http://127.0.0.1:8080/register");
      
    var _payload = jsonEncode(object);  
    
    var response = await client.post(url,body: _payload,headers: {
          "Content-Type": "application/json" 
        },);    
    return response;

  }
}