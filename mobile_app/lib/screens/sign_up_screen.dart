import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/api.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _role = 'trainer';

  final ApiService _apiService = ApiService();


  void _showErrorSnackBar(String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Создаем данные для отправки на сервер
    final data = {
      'name': _name,
      'email': _email,
      'password': _password,
      'role': _role,
    };

    try {
      // Используйте метод register из ApiService для отправки запроса на сервер
      final response = await _apiService.register(data);
      final token = response['token'];
      final role = response['role'];
      final userId = response['userId'];
      await Provider.of<AuthProvider>(context, listen: false).setToken(token, role, userId);

      // Переход на экран тренера или клиента в зависимости от роли
      // if (role == 'trainer') {
      //   Navigator.of(context).pushReplacementNamed(ClientsListScreen.routeName);
      // } else {
      //   // Навигация на экран клиента
      // }
    } catch (e) {
      // Если регистрация не удалась, показывайте ошибку
      print('Error: $e');
      _showErrorSnackBar('Не удалось зарегистрироваться. Проверьте введенные данные.');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Name is required' : null,
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ? 'Email is required' : null,
                  onSaved: (value) => _email = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) => value!.isEmpty ? 'Password is required' : null,
                  onSaved: (value) => _password = value!,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Role'),
                  value: _role,
                  items: [
                    DropdownMenuItem(value: 'trainer', child: Text('Trainer')),
                    DropdownMenuItem(value: 'client', child: Text('Client')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _role = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Sign Up'),
                ),
                TextButton(
                  onPressed: () {
                        Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
                  },
                  child: Text(
                    'Войти',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
