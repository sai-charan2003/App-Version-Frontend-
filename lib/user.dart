
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String? emailId;
    String? password;
    String? userName;
    String? token;
    String? apiKey;

    User({
        this.emailId,
        this.password,
        this.userName,
        this.token,
        this.apiKey,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        emailId: json["emailId"],
        password: json["password"],
        userName: json["userName"],
        token: json["token"],
        apiKey: json["apiKey"],
    );

    Map<String, dynamic> toJson() => {
        "emailId": emailId,
        "password": password,
        "userName": userName,
        "token": token,
        "apiKey": apiKey,
    };
}
