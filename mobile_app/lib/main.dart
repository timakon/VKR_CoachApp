import 'package:flutter/material.dart';
import 'package:my_app/screens/main_tabs_screen.dart';
import 'package:provider/provider.dart';
import 'providers/clients_provider.dart';
import 'providers/trainings_provider.dart';
import 'screens/training_list_screen.dart';
import 'screens/clients_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TrainingsProvider()),
        ChangeNotifierProvider(create: (ctx) => ClientsProvider()),
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
      home: MainTabsScreen(),
    );
  }
}