import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {


// GET REQUEST
  static Future<List?> fetchTodo() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['items'] as List<dynamic>;
      return result;
    }
    return null;
  }


  //DELETE REQUEST
  static Future<bool> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response.statusCode == 200;
  }


}
