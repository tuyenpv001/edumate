// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class RecognizerScreeen extends StatefulWidget {
//   File image;

//   RecognizerScreeen(this.image);

//   @override
//   State<RecognizerScreeen> createState() => _RecognizerScreeenState();
// }

// class _RecognizerScreeenState extends State<RecognizerScreeen> {
//   late TextRecognizer textRecognizer;
//   String results = "";
//   @override
//   void initState() {
//     super.initState();

//     textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     doTextRecognition();
//   }

//   Future<void> doTextRecognition() async {
//     InputImage inputImage = InputImage.fromFile(this.widget.image);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);

//     String text = recognizedText.text;
//     print(text);
//     setState(() {
//       results = text;
//     });
//     for (TextBlock block in recognizedText.blocks) {
//       final Rect rect = block.boundingBox;
//       final List<Point<int>> cornerPoint = block.cornerPoints;
//       final String text = block.text;
//       final List<String> languages = block.recognizedLanguages;

//       for (TextLine line in block.lines) {
//         for (TextElement element in line.elements) {}
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           'Trích xuất',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: [
//               Image.file(this.widget.image),
//               Card(
//                   margin: EdgeInsets.all(10),
//                   color: Colors.grey.shade300,
//                   child: Column(
//                     children: [
//                       Container(
//                         color: Colors.green,
//                         child: Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Kết quả",
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 18),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   Clipboard.setData(
//                                       ClipboardData(text: results));
//                                   SnackBar sn =
//                                       SnackBar(content: Text("copied"));
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(sn);
//                                 },
//                                 child: Icon(
//                                   Icons.copy,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {},
//                                 child: Icon(
//                                   Icons.note_add_outlined,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Text(
//                         results,
//                         style: TextStyle(fontSize: 18),
//                       )
//                     ],
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:math';

import 'package:edumate/ui/screens/note/items/note_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizerScreen extends StatefulWidget {
  final File image;

  RecognizerScreen(this.image);

  @override
  State<RecognizerScreen> createState() => _RecognizerScreenState();
}

class _RecognizerScreenState extends State<RecognizerScreen> {
  late TextRecognizer textRecognizer;
  TextEditingController resultController = TextEditingController();
  final noteService = NoteService();
  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    doTextRecognition();
  }

  Future<void> doTextRecognition() async {
    InputImage inputImage = InputImage.fromFile(widget.image);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    print(text);
    setState(() {
      resultController.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Trích xuất',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(widget.image),
            Card(
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  Container(
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kết quả",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: resultController.text));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Copied to clipboard")),
                                  );
                                },
                                child: Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  _showAddNoteModal(context);
                                },
                                child: Icon(
                                  Icons.note_add_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: resultController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Kết quả trích xuất",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteModal(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thêm Ghi Chú"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Tên ghi chú",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Nội dung ghi chú sẽ được lưu:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                resultController.text,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng modal
              },
              child: Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  bool success = await noteService.createNote(
                    name: name,
                    cateUuid: "",
                    content: resultController.text.trim(),
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ghi chú được tạo thành công!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tạo ghi chú thất bại!')),
                    );
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Tên ghi chú không được để trống!")),
                  );
                }
              },
              child: Text("Lưu"),
            ),
          ],
        );
      },
    );
  }
}
