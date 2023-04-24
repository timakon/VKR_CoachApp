import 'package:flutter/material.dart';
import 'package:my_app/screens/clients_list_screen.dart';
import 'package:my_app/screens/training_list_screen.dart';

class MainTabsScreen extends StatefulWidget {
  @override
  _MainTabsScreenState createState() => _MainTabsScreenState();
}


class _MainTabsScreenState extends State<MainTabsScreen> {

int _selectedIndex = 0;

List<Widget> _screens = [
  ClientsListScreen(),
  TrainingListScreen(),
];

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(
    title: Text('My App'),
  ),
  body: _screens[_selectedIndex],
  bottomNavigationBar: BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Clients',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.fitness_center),
        label: 'Trainings',
      ),
    ],
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,
  ),
);
  }
}
