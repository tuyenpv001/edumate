// import 'package:edumate/data/env/env.dart';
// import 'package:edumate/data/storage/secure_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flip_card/flip_card.dart';

// class FlashcardListScreen extends StatefulWidget {
//   final String categoryId;
//   final int isPublic;
//   FlashcardListScreen({required this.categoryId, required this.isPublic});

//   @override
//   _FlashcardListScreenState createState() => _FlashcardListScreenState();
// }

// class _FlashcardListScreenState extends State<FlashcardListScreen> {
//   List<Map<String, dynamic>> flashcards = [];
//   Color? _selectedColor;

//   @override
//   void initState() {
//     super.initState();
//     _loadFlashcards(widget.categoryId);
//   }

//   Future<void> _loadFlashcards(String categoryId) async {
//     try {
//       final token = await secureStorage.readToken();

//       final response = await http.get(
//         Uri.parse('${Environment.urlApi}/flashcard/getall/' +
//             widget.categoryId +
//             "?isPublic=" +
//             widget.isPublic.toString()),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'xxx-token': token!
//         },
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body)["data"];

//         setState(() {
//           flashcards = data.map((item) {
//             return {
//               "name": item["name"] ?? "",
//               "font": item["font"] ?? "",
//               "back": item["back"] ?? "",
//             };
//           }).toList();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load flashcards')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           'Flashcards',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.green.shade50,
//       body: flashcards.isEmpty
//           ? Center(
//               child: Text(
//                 'No flashcards available.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: flashcards.length,
//               itemBuilder: (context, index) {
//                 final flashcard = flashcards[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 16.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 8,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: FlipCard(
//                     direction: FlipDirection.HORIZONTAL,
//                     front: _buildFlashcardSide(
//                       title: flashcard["name"]!,
//                       content: flashcard["font"]!,
//                       backgroundColor: Colors.green.shade100,
//                       gradient: LinearGradient(
//                         colors: [Colors.green.shade200, Colors.green.shade50],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     back: _buildFlashcardSide(
//                       title: flashcard["name"]!,
//                       content: flashcard["back"]!,
//                       backgroundColor: Colors.green.shade200,
//                       gradient: LinearGradient(
//                         colors: [Colors.green.shade300, Colors.green.shade100],
//                         begin: Alignment.topRight,
//                         end: Alignment.bottomLeft,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   Widget _buildFlashcardSide({
//     required String title,
//     required String content,
//     required Color backgroundColor,
//     required Gradient gradient,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             content,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: Colors.black87),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;
import 'package:edumate/data/env/env.dart';
import 'package:edumate/data/storage/secure_storage.dart';
import 'package:edumate/ui/screens/flashcard/flashard_service.dart';
import 'package:flutter/material.dart';

class FlashcardListScreen extends StatefulWidget {
  final String categoryId;
  final int isPublic;

  FlashcardListScreen({required this.categoryId, required this.isPublic});

  @override
  _FlashcardListScreenState createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  List<Map<String, dynamic>> flashcards = [];
  final FlashcardService _flashcardService = FlashcardService();

  @override
  void initState() {
    super.initState();
    _loadFlashcards(widget.categoryId);
  }

  Future<void> _loadFlashcards(String categoryId) async {
    try {
      final token = await secureStorage.readToken();

      final response = await http.get(
        Uri.parse('${Environment.urlApi}/flashcard/getall/' +
            widget.categoryId +
            "?isPublic=" +
            widget.isPublic.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'xxx-token': token!
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)["data"];

        setState(() {
          flashcards = data.map((item) {
            return {
              "uuid": item["uuid"] ?? "",
              "name": item["name"] ?? "",
              "font": item["font"] ?? "",
              "back": item["back"] ?? "",
              "isPublic": item["public"] ?? 0,
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load flashcards')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _toggleFlashcardPublic(Map<String, dynamic> flashcard) async {
    final newPublicValue = flashcard["isPublic"] == 1 ? 0 : 1;
    final success = await _flashcardService.toggleFlashcardPublic(
      flashcard["uuid"],
      newPublicValue,
    );
    print(success);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Flashcard ${newPublicValue == 1 ? "is now public" : "is now private"}!',
          ),
        ),
      );
      setState(() {
        flashcard["isPublic"] = newPublicValue; // Cập nhật trạng thái
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update flashcard visibility.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Danh sách ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.green.shade50,
      body: flashcards.isEmpty
          ? Center(
              child: Text(
                'No flashcards available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Stack(
                    children: [
                      // FlipCard widget
                      Container(
                        width: double.infinity,
                        child: FlipCard(
                          fill: Fill.fillBack,
                          direction: FlipDirection.HORIZONTAL,
                          front: _buildFlashcardSide(
                            title: flashcard["name"]!,
                            content: flashcard["font"]!,
                            backgroundColor: Colors.green.shade100,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade200,
                                Colors.green.shade50
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          back: _buildFlashcardSide(
                            title: flashcard["name"]!,
                            content: flashcard["back"]!,
                            backgroundColor: Colors.green.shade200,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade300,
                                Colors.green.shade100
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                      ),
                      // Public Icon at the top-right
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            flashcard["isPublic"] == 1
                                ? Icons.public
                                : Icons.public_off,
                            color: flashcard["isPublic"] == 1
                                ? Colors.green
                                : Colors.grey,
                          ),
                          onPressed: () => _toggleFlashcardPublic(flashcard),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildFlashcardSide({
    required String title,
    required String content,
    required Color backgroundColor,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
