// import 'package:edumate/data/env/env.dart';
// import 'package:edumate/data/storage/secure_storage.dart';
// import 'package:edumate/ui/screens/flashcard/groups/add_category.dart';
// import 'package:edumate/ui/screens/flashcard/groups/add_flashcard.dart';
// import 'package:edumate/ui/screens/flashcard/groups/flashcard_list.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class FlashcardGroupScreen extends StatefulWidget {
//   @override
//   _FlashcardGroupScreenState createState() => _FlashcardGroupScreenState();
// }

// class _FlashcardGroupScreenState extends State<FlashcardGroupScreen> {
//   List<Map<String, dynamic>> quizGroups = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadFlashcards();
//   }

//   // Hàm gọi API để lấy danh sách nhóm flashcards
//   Future<void> _loadFlashcards() async {
//     try {
//       final token = await secureStorage.readToken();

//       final response = await http.get(
//         Uri.parse('${Environment.urlApi}/flashcard-cate/getall'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'xxx-token': token!
//         },
//       );

//       if (response.statusCode == 200) {
//         // Phân tích dữ liệu JSON từ API
//         List<dynamic> data = jsonDecode(response.body)["data"];

//         setState(() {
//           quizGroups = data.map((item) {
//             return {
//               "uuid": item["uuid"] ?? "",
//               "count": item["count"] ?? 0,
//               "name": item["name"] ?? "", // Tiêu đề nhóm
//               "color": item["color"] ?? "gray", // Mô tả nhóm
//             };
//           }).toList();
//         });
//       } else {
//         // Hiển thị thông báo lỗi nếu API không trả về thành công
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load quiz groups')),
//         );
//       }
//     } catch (e) {
//       // Xử lý lỗi nếu có vấn đề khi gọi API
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: quizGroups.length,
//         itemBuilder: (context, index) {
//           final group = quizGroups[index];
//           return Container(
//             margin: const EdgeInsets.only(bottom: 16.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 6,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.blue,
//                 child: Icon(Icons.quiz, color: Colors.white),
//               ),
//               title: Text(
//                 group["name"]!,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               subtitle: Text(group["count"]!.toString()),
//               trailing: Icon(Icons.arrow_forward_ios, size: 16),
//               onLongPress: (() {
//                 showDialog(
//                     context: context,
//                     builder: (context) => AddDialog(
//                           categoryId: group["uuid"],
//                           onAdded: _loadFlashcards,
//                         ));
//               }),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FlashcardListScreen(
//                         categoryId: group["uuid"],
//                         isPublic: 0), // Chuyển categoryId
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.orange,
//         child: Icon(Icons.add, color: Colors.white),
//         onPressed: () {
//           showDialog(
//               context: context,
//               builder: (context) => AddCategoryDialog(
//                     onCategoryAdded: _loadFlashcards,
//                   ));
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:edumate/ui/screens/flashcard/groups/add_category.dart';
import 'package:edumate/ui/screens/flashcard/groups/add_flashcard.dart';
import 'package:edumate/ui/screens/flashcard/groups/flashcard_list.dart';

class FlashcardGroupScreen extends StatefulWidget {
  @override
  _FlashcardGroupScreenState createState() => _FlashcardGroupScreenState();
}

class _FlashcardGroupScreenState extends State<FlashcardGroupScreen> {
  List<Map<String, dynamic>> quizGroups = [];

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  // Gọi API lấy danh sách nhóm flashcards
  Future<void> _loadFlashcards() async {
    try {
      final token = await secureStorage.readToken();

      final response = await http.get(
        Uri.parse('${Environment.urlApi}/flashcard-cate/getall'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)["data"];

        setState(() {
          quizGroups = data.map((item) {
            return {
              "uuid": item["uuid"] ?? "",
              "count": item["count"] ?? 0,
              "name": item["name"] ?? "",
              "color": item["color"] ?? "gray",
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load quiz groups')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50, // Nền xanh lá nhạt
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quizGroups.length,
        itemBuilder: (context, index) {
          final group = quizGroups[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade300,
                child: Icon(Icons.group, color: Colors.white),
              ),
              title: Text(
                group["name"]!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green.shade800,
                ),
              ),
              subtitle: Text(
                "${group["count"]} Flashcards",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AddDialog(
                    categoryId: group["uuid"],
                    onAdded: _loadFlashcards,
                  ),
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardListScreen(
                      categoryId: group["uuid"],
                      isPublic: 0,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green, // Nút thêm màu xanh lá cây
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddCategoryDialog(
              onCategoryAdded: _loadFlashcards,
            ),
          );
        },
      ),
    );
  }
}
