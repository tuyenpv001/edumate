import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlashcardService {
  Future<bool> toggleFlashcardPublic(String flashcardId, int isPublic) async {
    final token = await secureStorage.readToken();
    final url =
        Uri.parse('${Environment.urlApi}/flashcard/public/$flashcardId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
      body: jsonEncode({"isPublic": isPublic}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['resp'] ?? false;
    } else {
      return false;
    }
  }
}
