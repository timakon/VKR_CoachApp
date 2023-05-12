import 'package:flutter/material.dart';
import 'package:my_app/api.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/routers.dart';
import 'package:my_app/screens/Trainer/main_tabs_screen.dart';
import 'package:my_app/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

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
        'email': _email,
        'password': _password,
      };
      print(context);

      try {
        // Используйте метод login из ApiService для отправки запроса на сервер
        final response = await _apiService.login(data);
        final token = response['token'];
        final role = response['role'];
        final userId = response['userId'];
        await Provider.of<AuthProvider>(context, listen: false)
            .setToken(token, role, userId);

        // Переход на экран тренера или клиента в зависимости от роли
        if (role == 'trainer') {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainTabsScreen(),
          ),
        );
        } else {
          // Навигация на экран клиента
        }
      } catch (e) {
        // Если авторизация не удалась, показывайте ошибку
        print('Error: $e');
        _showErrorSnackBar('Не удалось войти. Проверьте введенные данные.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
                onSaved: (value) => _email = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value!.isEmpty ? 'Password is required' : null,
                onSaved: (value) => _password = value ?? '',
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Sign In'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Text(
                  'Зарегистрироваться',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
