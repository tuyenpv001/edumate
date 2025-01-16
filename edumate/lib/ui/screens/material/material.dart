// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:edumate/data/env/env.dart';
// import 'package:edumate/data/storage/secure_storage.dart';
// import 'package:edumate/ui/screens/material/items/quizz_mater.dart';
// import 'package:edumate/ui/widgets/widgets.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class UploadFileScreen extends StatefulWidget {
//   @override
//   _UploadFileScreenState createState() => _UploadFileScreenState();
// }

// class _UploadFileScreenState extends State<UploadFileScreen>
//     with SingleTickerProviderStateMixin {
//   String _response = '';
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> pickAndUploadFile() async {
//     final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['docx', 'pdf', 'xlsx', 'png', 'jpg']);

//     if (result != null) {
//       final token = await secureStorage.readToken();
//       final file = File(result.files.single.path!);
//       final uri = Uri.parse('${Environment.urlApi}/upload');
//       final request = http.MultipartRequest('POST', uri);
//       request.headers.addAll({'xxx-token': token!});
//       request.files.add(await http.MultipartFile.fromPath('file', file.path));
//       final response = await request.send();

//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         setState(() {
//           _response = "Tải lên thành công!";
//         });
//       } else {
//         setState(() {
//           _response = 'Tải lên thất bại: ${response.statusCode}';
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const BottomNavigation(index: 8),
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           'Tài liệu',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           tabs: [
//             Tab(text: 'Upload tệp tin'),
//             Tab(text: 'Câu hỏi'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 GestureDetector(
//                   onTap: pickAndUploadFile,
//                   child: DottedBorderContainer(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.cloud_upload, size: 50, color: Colors.green),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Chọn ảnh/ file word, excel, pdf',
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       _response,
//                       style: TextStyle(fontSize: 16, color: Colors.black87),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           QuizManagementScreen(),
//         ],
//       ),
//     );
//   }
// }

// // Widget Dotted Border Container
// class DottedBorderContainer extends StatelessWidget {
//   final Widget child;

//   const DottedBorderContainer({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.green,
//           width: 2,
//           style: BorderStyle.solid,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: DottedBorder(
//         borderType: BorderType.RRect,
//         radius: Radius.circular(16),
//         color: Colors.green,
//         strokeWidth: 2,
//         dashPattern: [6, 3],
//         child: Center(child: child),
//       ),
//     );
//   }
// }

import 'package:edumate/ui/screens/material/items/material_screen.dart';
import 'package:edumate/ui/screens/material/items/upload_screen.dart';
import 'package:edumate/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:edumate/ui/screens/material/items/quizz_mater.dart';

class UploadFileScreen extends StatefulWidget {
  @override
  _UploadFileScreenState createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 8),
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Tài liệu'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Upload tệp tin'),
            Tab(text: 'Câu hỏi'),
            Tab(text: 'File, tài liệu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UploadFileWidget(),
          QuizManagementScreen(),
          MaterialManagementScreen(),
        ],
      ),
    );
  }
}
