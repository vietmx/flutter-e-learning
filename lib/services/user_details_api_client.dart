import 'dart:convert';
import 'package:http/http.dart' as http;

class UserDetailsApiClient {
  final String baseUrl;

  UserDetailsApiClient({required this.baseUrl});

  Future<Map<String, dynamic>> getUserDetails(String token) async {
  final url = Uri.parse('$baseUrl/student/dashboard');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
     print('User Details Response: $token');
    print('User Details Response: $url');
    return data;
    
  } else {
    print('User Details Response: $token');
    print('User Details Response: $url'); // This line is causing the error
     // This line is causing the error
    throw Exception('Failed to load user details');
  }
}

}
class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final int status;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  print('User JSON: $json'); // Debug print
  return User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    address: json['address'],
    status: json['status'],
    roleId: json['role_id'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}


}
