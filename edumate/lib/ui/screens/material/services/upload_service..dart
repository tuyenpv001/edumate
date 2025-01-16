import 'dart:convert';
import 'dart:io';

import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UploadService {
  Future<String> uploadFile(File file, String groupId) async {
    try {
      final token = await secureStorage.readToken();
      print(groupId);
      final uri =
          Uri.parse('${Environment.urlApi}/upload?group_uid=${groupId}');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({'xxx-token': token!});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        return "Tệp đã được tải lên thành công!";
      } else {
        return 'Tải lên thất bại: ${response.statusCode}';
      }
    } catch (e) {
      return 'Lỗi khi tải lên: $e';
    }
  }

  Future<String> uploadMaterialFile(File file) async {
    try {
      final token = await secureStorage.readToken();
      final uri = Uri.parse('${Environment.urlApi}/material/upload');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({'xxx-token': token!});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        return "Tệp đã được tải lên thành công (Material)!";
      } else {
        return 'Tải lên thất bại (Material): ${response.statusCode}';
      }
    } catch (e) {
      return 'Lỗi khi tải lên (Material): $e';
    }
  }

  Future<Map<String, dynamic>> fetchMaterials(
      {required int pageSize, required int page, String? keyword}) async {
    try {
      final token = await secureStorage.readToken();
      final uri = Uri.parse(
          '${Environment.urlApi}/material/getall?pageSize=$pageSize&page=$page&keyword=${keyword ?? ''}');
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch materials');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteMaterial(String uuid) async {
    try {
      final token = await secureStorage.readToken();
      final uri = Uri.parse('${Environment.urlApi}/material/delete/$uuid');
      final response = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      });

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
