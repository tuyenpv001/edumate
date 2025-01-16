import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddDialog extends StatefulWidget {
  final String categoryId;
  final Function() onAdded;

  AddDialog({required this.categoryId, required this.onAdded});

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note to Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _fontController,
            decoration: InputDecoration(labelText: 'Mặt trước'),
          ),
          TextField(
            controller: _backController,
            decoration: InputDecoration(labelText: 'Mặt sau'),
          ),
          TextField(
            controller: _colorController,
            decoration: InputDecoration(labelText: 'Màu sắc'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String name = _nameController.text.trim();
            String font = _fontController.text.trim();
            String back = _backController.text.trim();
            String color = _colorController.text.trim();

            if (name.isEmpty || font.isEmpty || back.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter both title and content')),
              );
              return;
            }

            // Handle the submit
            await _handleSubmit(name, font, back, color);

            widget.onAdded();
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(
      String name, String font, String back, String color) async {
    try {
      final token = await secureStorage.readToken();
      final response = await http.post(
        Uri.parse('${Environment.urlApi}/flashcard/create'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!,
        },
        body: jsonEncode({
          "name": name,
          "font": font,
          "back": back,
          "color": color,
          "cate_uuid": widget.categoryId,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully added note
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note added successfully')),
        );
        Navigator.pop(context); // Close the dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
