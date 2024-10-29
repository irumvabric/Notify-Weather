import 'package:http/http.dart' as http;
import 'dart:convert';

// Future<void> signUp(String email, String password) async {
//   final response = await http.post(
//     Uri.parse('https://127.0.0.1:8000/user/signup/'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'email': email, 'password': password}),
//   );

//   if (response.statusCode == 201) {
//     print('User signed up successfully');
//   } else {
//     print('Failed to sign up: ${response.body}');
//   }
// }

// Future<void> signIn(String email, String password) async {
//   final response = await http.post(
//     Uri.parse('https://127.0.0.1:8000/user/signin/'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'email': email, 'password': password}),
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     print('Token: ${data['token']}');
//   } else {
//     print('Failed to sign in: ${response.body}');
//   }
// }

class AuthService {
  static const String baseUrl = 'https://127.0.0.1:8000';

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? name,
    String? phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/signup/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'phone_number': phoneNumber,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['message'] ?? 'Sign up failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/signin/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Store token securely
        //await secureStorage.write(key: 'auth_token', value: data['token']);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['message'] ?? 'Sign in failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error occurred'};
    }
  }
}
