import 'package:flutter/material.dart';
import 'package:weather/pages/home_screen.dart';
import 'package:weather/pages/maps_screen.dart';
import 'package:weather/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Django Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Django Auth'),
      home: const MyHomePage(title: 'Hola'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLogin = true;

  final AuthService _authService = AuthService();

  void _login() async {
    final response = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (response != null) {
      print('Login successful: $response');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home_Screen()),
      );
    } else {
      print('Login failed');
    }
  }

  void _signup() async {
    final response = await _authService.signup(
      _usernameController.text,
      _passwordController.text,
      _emailController.text,
    );

    if (response != null) {
      print('Signup successful: $response');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Vérification de l\'email'),
          content: const Text(
              'Veuillez vérifier votre email pour activer votre compte.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print('Signup failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (!_isLogin)
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLogin ? _login : _signup,
              child: Text(_isLogin ? 'Login' : 'Signup'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                  _isLogin ? 'Create an account' : 'Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }
}
