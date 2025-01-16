import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNoteDialog extends StatefulWidget {
  final String categoryId;

  AddNoteDialog({required this.categoryId});

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note to Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Note Title'),
          ),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(labelText: 'Note Content'),
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
            String noteTitle = _titleController.text.trim();
            String noteContent = _contentController.text.trim();

            if (noteTitle.isEmpty || noteContent.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter both title and content')),
              );
              return;
            }

            // Handle the submit
            await _handleSubmit(noteTitle, noteContent);
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(String title, String content) async {
    try {
      final token = await secureStorage.readToken();
      final response = await http.post(
        Uri.parse('${Environment.urlApi}/note/create'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!,
        },
        body: jsonEncode({
          "name": title,
          "content": content,
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
          SnackBar(content: Text('Failed to add note')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
