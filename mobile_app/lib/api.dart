import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://10.0.2.2:5000";

  Future<List<dynamic>> getAll(String endpoint) async {
    final response = await http.get(Uri.parse("$_baseUrl/$endpoint"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<dynamic> getById(String endpoint, String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/$endpoint/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  // Future<dynamic> add(String endpoint, Map<String, dynamic> data) async {
  //   final response = await http.post(
  //     Uri.parse("$_baseUrl/$endpoint/add"),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(data),
  //   );

  //   if (response.statusCode == 201) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception("Failed to add data");
  //   }
  // }

  Future<dynamic> add(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/$endpoint/add"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Failed to add data. Status code: ${response.statusCode}. Response body: ${response.body}");
    }
  }

  Future<List<dynamic>> getTrainings() async {
    final response = await http.get(Uri.parse('$_baseUrl/trainings'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData;
    } else {
      throw Exception('Failed to load trainings');
    }
  }

  Future<dynamic> update(
      String endpoint, String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/$endpoint/update/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to update data. Status Code: ${response.statusCode}");
      print("Error Message: ${response.body}");
      throw Exception("Failed to update data");
    }
  }

  Future<dynamic> delete(String endpoint, String id) async {
    final response =
        await http.delete(Uri.parse("$_baseUrl/$endpoint/delete/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to delete data");
    }
  }
}
