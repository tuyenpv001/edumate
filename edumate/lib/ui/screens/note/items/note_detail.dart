import 'package:edumate/ui/helpers/date_time_helper.dart';
import 'package:edumate/ui/screens/note/items/note_service.dart';
import 'package:flutter/material.dart';
import 'package:edumate/ui/widgets/widgets.dart';

class NoteDetailScreen extends StatefulWidget {
  final String uuid;

  const NoteDetailScreen({Key? key, required this.uuid}) : super(key: key);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final NoteService _noteService = NoteService();
  Map<String, dynamic>? noteData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNoteDetails();
  }

  Future<void> _fetchNoteDetails() async {
    final data = await _noteService.getNoteById(widget.uuid);
    setState(() {
      noteData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Chi tiết ghi chú',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : noteData == null
              ? Center(
                  child: Text(
                    'Không thể tải thông tin ghi chú.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              : _buildNoteDetailContent(),
    );
  }

  Widget _buildNoteDetailContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên ghi chú
          Text(
            noteData!['name'] ?? 'Không có tiêu đề',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Ngày tạo
          Text(
            'Ngày tạo: ${TimeHelper.formatDateTime(noteData!['created_at']!)}',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey),
          const SizedBox(height: 8),
          // Nội dung
          Text(
            noteData!['content'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
