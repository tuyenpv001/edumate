import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCategoryDialog extends StatefulWidget {
  final Function() onCategoryAdded;

  AddCategoryDialog({required this.onCategoryAdded});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  bool _isLoading = false;

  // Hàm kiểm tra và chuyển đổi giá trị màu sắc
  Color _getColorFromString(String colorStr) {
    try {
      if (colorStr.isEmpty)
        return Colors.grey; // Giá trị mặc định nếu không có màu
      if (colorStr.startsWith('#')) {
        // Chuyển đổi từ mã hex (ví dụ: #FF5733)
        colorStr = colorStr.replaceAll('#', '0xFF');
      }
      return Color(
          int.parse(colorStr)); // Chuyển đổi từ hex string hoặc giá trị số
    } catch (e) {
      return Colors.grey; // Trả về màu mặc định nếu có lỗi
    }
  }

  // Hàm gọi API lưu danh mục
  Future<void> _saveCategory(String name, String color) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await secureStorage.readToken();
      final response = await http.post(
        Uri.parse(
            '${Environment.urlApi}/flashcard-cate/create'), // Thay bằng URL của API
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'color': color.isNotEmpty
              ? color
              : 'default', // Giá trị mặc định nếu không có màu
        }),
      );

      if (response.statusCode == 200) {
        // Lưu thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully!')),
        );
      } else {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                errorText: _nameController.text.isEmpty && _isLoading
                    ? 'Name cannot be empty'
                    : null,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(
                labelText: 'Color (Optional)',
              ),
            ),
            if (_isLoading) ...[
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Đóng dialog

            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String name = _nameController.text.trim();
            String color = _colorController.text.trim();

            if (name.isNotEmpty) {
              // Kiểm tra và chuyển đổi màu
              Color finalColor = _getColorFromString(color);

              // Gọi API lưu danh mục
              await _saveCategory(name, color);

              // Đóng dialog nếu thành công
              if (!_isLoading) {
                widget.onCategoryAdded();
                Navigator.of(context).pop();
              }
            } else {
              // Hiển thị thông báo lỗi nếu tên danh mục rỗng
              setState(() {});
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
