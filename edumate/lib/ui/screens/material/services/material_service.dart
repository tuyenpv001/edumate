import 'dart:convert';
import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

class QuizzService {
  Future<Map<String, dynamic>> fetchQuizzes(
      {int page = 1, String query = ''}) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse(
        '${Environment.urlApi}/quizz/getall?page=$page&keyword=$query');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['resp'] == true) {
        return {
          'data': data['data'],
          'total': data['total'],
          'totalPages': data['totalPages'],
        };
      } else {
        throw Exception('Failed to fetch quizzes: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch quizzes');
    }
  }

  Future<bool> updateQuiz(String uuid, Map<String, dynamic> data) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/quizz/update/result/$uuid');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }

  Future<bool> updateQuizDetail(String uuid, Map<String, dynamic> data) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/quizz/update/$uuid');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteQuiz(String uuid) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/quizz/delete/$uuid');

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

  Future<List<dynamic>> fetchGroups() async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/quizz-group/getall');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['resp'] == true) {
        return data['data'];
      } else {
        throw Exception('Failed to fetch groups: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch groups');
    }
  }

  // API cập nhật nhóm cho câu hỏi
  Future<bool> updateQuizGroup(String uuid, String groupUid) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/quizz/update/group/$uuid');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
      body: jsonEncode({'group_uid': groupUid}),
    );

    return response.statusCode == 200;
  }

  Future<bool> createGroup(String name) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/quizz-group/create');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
      body: jsonEncode({'name': name}),
    );

    return response.statusCode == 200;
  }

  Future<List<dynamic>> fetchRandomQuestions(int number, String groupId) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse(
        '${Environment.urlApi}/quizz/generate-random?numQuestions=${number}&groupId=${groupId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['resp'] == true) {
        return data['data'];
      } else {
        throw Exception('Failed to fetch groups: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch groups');
    }
  }

  Future<List<dynamic>> fetchQuestionByGroup(String groupId) async {
    print(groupId);
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/quizz/getall/${groupId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['resp'] == true) {
        return data['data'];
      } else {
        throw Exception('Failed to fetch groups: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch groups');
    }
  }
}
