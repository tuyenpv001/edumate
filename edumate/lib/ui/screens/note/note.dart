import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:edumate/services/db_service.dart';
import 'package:edumate/ui/helpers/date_time_helper.dart';
import 'package:edumate/ui/screens/note/items/add_note.dart';
import 'package:edumate/ui/screens/note/items/category_widget.dart';
import 'package:edumate/ui/screens/note/items/note_detail.dart';
import 'package:edumate/ui/screens/note/items/note_service.dart';
import 'package:edumate/ui/themes/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edumate/ui/screens/note/items/add_category.dart';
import 'package:edumate/ui/widgets/widgets.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Danh sách ghi chú (mock data)
  late List<Map<String, dynamic>> pinnedNotes;
  late List<Map<String, dynamic>> upcomingNotes;
  final NoteService _noteService = NoteService();
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 3),
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          'Notes',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số cột là 2
                  crossAxisSpacing: 10, // Khoảng cách giữa các cột
                  mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                ),
                itemCount: pinnedNotes.length + upcomingNotes.length,
                itemBuilder: (context, index) {
                  final note = index < pinnedNotes.length
                      ? pinnedNotes[index]
                      : upcomingNotes[index - pinnedNotes.length];

                  return _buildNoteCard(note, Colors.blue.shade100);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showCategoryModal();
        },
      ),
    );
  }

  // Section for Notes
  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> notes,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return _buildNoteCard(note, backgroundColor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note, Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailScreen(uuid: note['uuid']),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note["title"]!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              note["content"]!,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              TimeHelper.formatDateTime(note["time"]!),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.notification_add_outlined,
                        color: Colors.green),
                    onPressed: () async {
                      final dbHelper = DBHelper();
                      try {
                        await dbHelper.insertNote(
                          uuid: note["uuid"],
                          title: note["title"]!,
                          content: note["content"]!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Ghi chú đã được thêm vào thông báo!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add note: $e')),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_off_outlined,
                        color: Colors.red),
                    onPressed: () async {
                      final dbHelper = DBHelper();
                      try {
                        await dbHelper
                            .deleteNote(note["uuid"]); // Remove by UUID
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Ghi chú đã được xóa ra khỏi thông báo!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi khi xóa: $e')),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () async {
                      _showEditNoteDialog(context, note, _noteService);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed =
                          await _showDeleteConfirmationDialog(context, note);
                      if (confirmed) {
                        final success =
                            await _noteService.deleteNoteByUuid(note["uuid"]);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Note deleted successfully!')),
                          );
                          setState(() {
                            pinnedNotes
                                .removeWhere((n) => n['uuid'] == note["uuid"]);
                            upcomingNotes
                                .removeWhere((n) => n['uuid'] == note["uuid"]);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to delete note.')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return CategoryList(
          onCategorySelected: (categoryId) {
            _showAddNoteDialog(categoryId); // Mở dialog khi chọn danh mục
          },
        );
      },
    );
  }

  void _showAddNoteDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AddNoteDialog(categoryId: categoryId);
      },
    );
  }

  Future<void> _loadNotes() async {
    try {
      final token = await secureStorage.readToken();

      final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/note/getall'), // API URL lấy danh sách ghi chú
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)["data"];

        setState(() {
          pinnedNotes = data.map((note) {
            return {
              "uuid": note["uuid"] ?? "",
              "title": note["name"] ?? "",
              "content": note["content"] ?? "",
              "time": note["created_at"] ?? "",
            };
          }).toList();

          upcomingNotes =
              data.where((note) => note['pinned'] == false).map((note) {
            return {
              "uuid": note["uuid"] ?? "",
              "title": note["name"] ?? "",
              "content": note["content"] ?? "",
              "time": note["created_at"] ?? "",
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notes')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showEditNoteDialog(BuildContext context, Map<String, dynamic> note,
      NoteService noteService) {
    final TextEditingController titleController =
        TextEditingController(text: note["title"]);
    final TextEditingController contentController =
        TextEditingController(text: note["content"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppColors.primary)),
              onPressed: () async {
                final updatedTitle = titleController.text.trim();
                final updatedContent = contentController.text.trim();

                final success = await noteService.updateNoteByUuid(
                    note["uuid"], updatedTitle, updatedContent);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Note updated successfully!')),
                  );
                  _loadNotes();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update note.')),
                  );
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> note) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete Note'),
              content: Text('Are you sure you want to delete this note?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false); // Hủy xóa
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context, true); // Đồng ý xóa
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
