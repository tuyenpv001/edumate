import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';

class ProfileService {
  Future<dynamic> getProfile() async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/user/profile');

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

  Future<bool> updateFullName(String newFullName) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/user/update/fullname');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
      body: jsonEncode({'fullname': newFullName}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['resp'] == true) {
        return true;
      } else {
        throw Exception('Failed to update fullname: ${data['message']}');
      }
    } else {
      throw Exception('Failed to update fullname');
    }
  }

  Future<bool> updateProfileImage(File image) async {
    final token = await secureStorage.readToken();
    final url = Uri.parse('${Environment.urlApi}/user/update-image-profile');

    final request = http.MultipartRequest('PUT', url);
    request.headers['xxx-token'] = token!;
    request.files.add(await http.MultipartFile.fromPath('profile', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (data['resp'] == true) {
        return true; // Cập nhật thành công
      } else {
        throw Exception('Failed to update profile image: ${data['message']}');
      }
    } else {
      throw Exception('Failed to update profile image');
    }
  }
}
