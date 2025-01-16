// import 'package:edumate/data/env/env.dart';
// import 'package:edumate/data/storage/secure_storage.dart';
// import 'package:edumate/ui/screens/flashcard/groups/flashcard_list.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class FlashcardPublicScreen extends StatefulWidget {
//   @override
//   _FlashcardPublicScreenState createState() => _FlashcardPublicScreenState();
// }

// class _FlashcardPublicScreenState extends State<FlashcardPublicScreen> {
//   List<Map<String, dynamic>> flashcardTopics = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchFlashcardData();
//   }

//   Future<void> _fetchFlashcardData() async {
//     final token = await secureStorage.readToken();

//     final response = await http.get(
//       Uri.parse('${Environment.urlApi}/flashcard-cate/public'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'xxx-token': token!
//       },
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body)["data"];

//       setState(() {
//         flashcardTopics = data.map((item) {
//           return {
//             "uuid": item['uuid'] ?? "",
//             'title': item['name'] ?? "",
//             'creator_name': item['creator_name'] ?? "",
//             'phrases': item['count'] ?? 0,
//             'color': _getColorFromString(item['color']),
//           };
//         }).toList();
//       });
//     } else {
//       throw Exception('Failed to load flashcard topics');
//     }
//   }

//   Color _getColorFromString(String color) {
//     switch (color.toLowerCase()) {
//       case 'blue':
//         return Colors.blue[100]!;
//       case 'pink':
//         return Colors.pink[100]!;
//       case 'yellow':
//         return Colors.yellow[100]!;
//       default:
//         return Colors.grey[100]!;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: flashcardTopics.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: flashcardTopics.length,
//                       itemBuilder: (context, index) {
//                         final topic = flashcardTopics[index];
//                         return _buildFlashcardTopicCard(
//                           uuid: topic["uuid"],
//                           title: topic["title"],
//                           creator_name: topic["creator_name"],
//                           phrases: topic["phrases"],
//                           color: topic["color"],
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget for each Flashcard Topic Card
//   Widget _buildFlashcardTopicCard({
//     required String uuid,
//     required String title,
//     required String creator_name,
//     required int phrases,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Text(
//             title,
//             style: TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//           const SizedBox(height: 8),
//           // Contributors
//           Row(
//             children: [
//               Text(
//                 "Người tạo:",
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//               const SizedBox(width: 8),
//               Text(creator_name,
//                   style: TextStyle(fontSize: 16, color: Colors.black87)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Phrases and Action
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "$phrases flashcard",
//                 style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           FlashcardListScreen(categoryId: uuid, isPublic: 1),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Text("Start", style: TextStyle(fontSize: 14)),
//                     Icon(Icons.arrow_forward, size: 16),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:edumate/ui/screens/flashcard/groups/flashcard_list.dart';

class FlashcardPublicScreen extends StatefulWidget {
  @override
  _FlashcardPublicScreenState createState() => _FlashcardPublicScreenState();
}

class _FlashcardPublicScreenState extends State<FlashcardPublicScreen> {
  List<Map<String, dynamic>> flashcardTopics = [];

  @override
  void initState() {
    super.initState();
    _fetchFlashcardData();
  }

  Future<void> _fetchFlashcardData() async {
    final token = await secureStorage.readToken();

    final response = await http.get(
      Uri.parse('${Environment.urlApi}/flashcard-cate/public'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'xxx-token': token!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)["data"];

      setState(() {
        flashcardTopics = data.map((item) {
          return {
            "uuid": item['uuid'] ?? "",
            'title': item['name'] ?? "",
            'creator_name': item['creator_name'] ?? "",
            'phrases': item['count'] ?? 0,
            'color': _getColorFromString(item['color']),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load flashcard topics');
    }
  }

  Color _getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'green':
        return Colors.green.shade100;
      case 'yellow':
        return Colors.yellow.shade100;
      case 'orange':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: flashcardTopics.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: flashcardTopics.length,
                      itemBuilder: (context, index) {
                        final topic = flashcardTopics[index];
                        return _buildFlashcardTopicCard(
                          uuid: topic["uuid"],
                          title: topic["title"],
                          creator_name: topic["creator_name"],
                          phrases: topic["phrases"],
                          color: topic["color"],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each Flashcard Topic Card
  Widget _buildFlashcardTopicCard({
    required String uuid,
    required String title,
    required String creator_name,
    required int phrases,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 8),
          // Contributors
          Row(
            children: [
              Text(
                "Người tạo:",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(width: 8),
              Text(
                creator_name,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Phrases and Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$phrases flashcard",
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FlashcardListScreen(categoryId: uuid, isPublic: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Nút màu xanh lá
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Text("Start", style: TextStyle(fontSize: 14)),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
