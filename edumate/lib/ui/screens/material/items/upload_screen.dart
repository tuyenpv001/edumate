import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:edumate/ui/screens/material/services/material_service.dart';
import 'package:edumate/ui/screens/material/services/upload_service..dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadFileWidget extends StatefulWidget {
  const UploadFileWidget({Key? key}) : super(key: key);

  @override
  _UploadFileWidgetState createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  final UploadService _uploadService = UploadService();
  final QuizzService _quizzService = QuizzService();
  File? _selectedFile;
  List<dynamic> _groups = [];
  String? _selectedGroup;
  String _responseMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      final groups = await _quizzService.fetchGroups();
      setState(() {
        _groups = groups;
        _selectedGroup = groups.isNotEmpty ? groups.first['uuid'] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải danh sách nhóm: $e')),
      );
    }
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf', 'xlsx', 'png', 'jpg'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _handleSaveFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn tệp!')),
      );
      return;
    }

    final responseMessage =
        await _uploadService.uploadMaterialFile(_selectedFile!);
    setState(() {
      _responseMessage = responseMessage;
    });
  }

  Future<void> _handleCreateQuestion() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn tệp!')),
      );
      return;
    }

    if (_selectedGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn nhóm câu hỏi!')),
      );
      return;
    }

    final responseMessage =
        await _uploadService.uploadFile(_selectedFile!, _selectedGroup!);
    setState(() {
      _responseMessage = responseMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _selectFile,
              child: DottedBorderContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, size: 50, color: Colors.green),
                    const SizedBox(height: 8),
                    Text(
                      'Chọn ảnh/ file word, excel, pdf',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_selectedFile != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tệp đã chọn: ${_selectedFile!.path.split('/').last}',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedGroup,
                    decoration: InputDecoration(
                      labelText: 'Chọn nhóm câu hỏi',
                      border: OutlineInputBorder(),
                    ),
                    items: _groups.map((group) {
                      return DropdownMenuItem<String>(
                        value: group['uuid'],
                        child: Text(group['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGroup = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _handleSaveFile,
                    icon: Icon(Icons.save),
                    label: Text('Lưu tài liệu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _handleCreateQuestion,
                    icon: Icon(Icons.quiz),
                    label: Text('Tạo câu hỏi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _responseMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Widget Dotted Border Container
class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(16),
        color: Colors.green,
        strokeWidth: 2,
        dashPattern: [6, 3],
        child: Center(child: child),
      ),
    );
  }
}
