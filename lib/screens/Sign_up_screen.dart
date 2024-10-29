import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notifyweather/services/auth.dart';
import 'package:notifyweather/main.dart';
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  final ctx = navigatorKey.currentContext as BuildContext;

  final AuthService _authService = AuthService();

  // Future<void> signUp(String email, String password) async {
  //   final response = await http.post(
  //     Uri.parse('https://127.0.0.1:8000/user/signup/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );

  //   if (response.statusCode == 201) {
  //     print('User signed up successfully');
  //     Navigator.pushReplacementNamed(
  //         context, '/home'); // Navigate to home after signup
  //   } else {
  //     print('Failed to sign up: ${response.body}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to sign up: ${response.body}')),
  //     );
  //   }
  // }

  // Future<void> _handleSignUp() async {
  //   setState(() => _isLoading = true);
  //   if (_formKey.currentState?.validate() ?? false) {
  //     await signUp(_emailController.text, _passwordController.text);
  //   }
  //   setState(() => _isLoading = false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        _authService.signUp(
                          email: _emailController.text,
                          password: _passwordController.text,
                          name: _nameController.text,
                          phoneNumber: _phoneNumberController.text,
                        );
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(ctx, '/screens/Home');
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
