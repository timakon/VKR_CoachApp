import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/client.dart';

class ClientsProvider with ChangeNotifier {
  List<Client> _clients = [];

  List<Client> get clients {
    return _clients;
  }

  Future<void> fetchClients() async {
    final url = 'http://10.0.2.2:5000/users/clients'; // измените на ваш URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      _clients = responseData.map((clientData) => Client(
        id: clientData['_id'],
        name: clientData['name'],
        email: clientData['email'],
      )).toList();
      notifyListeners();
    } else {
      print('Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception("Failed to load clients");
    }
  }

  String getClientName(String clientId) {
    final client = _clients.firstWhere((client) => client.id == clientId, orElse: () => Client(id: '', name: 'Unknown client', email: ''));
    return client.name;
  }

  Client getClientById(String clientId) {
    return _clients.firstWhere((client) => client.id == clientId, orElse: () => Client(id: '', name: 'Unknown client', email: ''));
  }
}