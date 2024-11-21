import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse('$baseUrl/employees'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar os dados: ${response.statusCode}');
    }
  }
}
