import 'package:elearning/ui/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseURL = "http://10.0.2.2:8000/api/";

class ApiServiceRegister {
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'phone_number': phoneNumber,
      'address': address,
    };
    
    final response = await http.post(
      Uri.parse(baseURL + 'student/register'),
      headers: headers,
      body: json.encode(data),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return json.decode(response.body);
  }
}

class ApiServiceLogin {
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };
    
    final response = await http.post(
      Uri.parse(baseURL + 'student/login'),
      headers: headers,
      body: json.encode(data),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return json.decode(response.body);
  }
}

final Map<String, String> headers = {
  "Content-Type": "application/json",
};

void handleLogOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          CupertinoDialogAction(
            child: Text('Log Out'),
            onPressed: () async {
              // Perform token removal logic here
              // For example, using SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              
              // Navigate to the login page and prevent going back
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}
