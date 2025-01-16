import 'package:edumate/ui/screens/note/items/add_category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';

class CategoryList extends StatefulWidget {
  final Function(String) onCategorySelected;

  CategoryList({required this.onCategorySelected});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Hàm gọi API để lấy danh mục
  Future<void> _loadCategories() async {
    try {
      final token = await secureStorage.readToken();

      final response = await http.get(
        Uri.parse('${Environment.urlApi}/category/getall'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)["data"];

        setState(() {
          categories = data.map((item) {
            return {
              "uuid": item["uuid"] ?? "",
              "name": item["name"] ?? "",
              "count": item["count"] ?? 0,
              "color": item["color"].toString(),
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Chuyển đổi tên màu thành đối tượng Color
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                print(category);

                Color categoryColor;
                try {
                  categoryColor = _getColorFromName(category["color"]);
                } catch (e) {
                  categoryColor = Colors.grey; // Default color if invalid
                }
                return ListTile(
                  leading: Icon(Icons.folder, color: categoryColor),
                  title: Text(category["name"]!),
                  trailing: Text(category["count"].toString()),
                  onLongPress: (() {
                    _showDeleteConfirmDialog(category["uuid"]!);
                  }),
                  onTap: () {
                    widget.onCategorySelected(category["uuid"]!);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    AddCategoryDialog(onCategoryAdded: _loadCategories),
              );
              _loadCategories();
            },
            icon: Icon(Icons.add),
            label: Text("Create New Category"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Category"),
        content: Text("Are you sure you want to delete this category?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng modal
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng modal
              _deleteCategory(categoryId); // Xóa danh mục
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(String categoryId) async {
    try {
      final token = await secureStorage.readToken();

      final response = await http.delete(
        Uri.parse('${Environment.urlApi}/category/delete/$categoryId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!,
        },
      );

      if (response.statusCode == 200) {
        // Thành công, bạn có thể cập nhật lại danh sách hoặc thông báo cho người dùng
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category deleted successfully')),
        );
        _loadCategories(); // Tải lại danh mục sau khi xóa
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
