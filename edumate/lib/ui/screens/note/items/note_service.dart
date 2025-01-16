import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';

class NoteService {
  Future<bool> deleteNoteByUuid(String uuid) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/note/delete/$uuid');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> updateNoteByUuid(
      String uuid, String title, String content) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/note/update');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
      body: jsonEncode({
        'uuid': uuid,
        'name': title,
        'content': content,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> createNote({
    required String name,
    required String cateUuid,
    required String content,
  }) async {
    try {
      final token = await secureStorage.readToken();
      final url = Uri.parse('${Environment.urlApi}/note/create');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!,
        },
        body: jsonEncode({
          'name': name,
          'cate_uuid': cateUuid,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['resp'] == true; // Kiểm tra phản hồi từ server
      } else {
        print('Failed to create note: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in createNote: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getNoteById(String uuid) async {
    try {
      final token = await secureStorage.readToken();
      final url = Uri.parse('${Environment.urlApi}/note/getId/$uuid');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['resp'] == true) {
          return responseData['data'];
        }
      }
      print('Failed to fetch note: ${response.body}');
      return null;
    } catch (e) {
      print('Error in getNoteById: $e');
      return null;
    }
  }
}
