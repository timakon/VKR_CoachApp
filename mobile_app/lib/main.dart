import 'package:flutter/material.dart';
import 'package:my_app/screens/Client/cl.dart';
import 'package:my_app/screens/Trainer/client_details_screen.dart';
import 'package:my_app/screens/Trainer/main_tabs_screen.dart';
import 'package:my_app/screens/sign_in_screen.dart';
import 'package:my_app/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'providers/clients_provider.dart';
import 'providers/trainings_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/Trainer/training_list_screen.dart';
import 'screens/Trainer/clients_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TrainingsProvider()),
        ChangeNotifierProvider(create: (ctx) => ClientsProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Provider.of<AuthProvider>(context, listen: false)
            .getStoredTokenAndRole(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final isAuthenticated =
                Provider.of<AuthProvider>(context).isAuthenticated;
            if (isAuthenticated) {
              final userRole = Provider.of<AuthProvider>(context).userRole;
              if (userRole == 'trainer') {
                return MainTabsScreen();
              } else {
                return Cl();
              }
            } else {
              return SignInScreen();
            }
          }
        },
      ),
    );
  }
}
