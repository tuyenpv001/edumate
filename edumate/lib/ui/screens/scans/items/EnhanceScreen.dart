import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

class EnhanceScreen extends StatefulWidget {
  File image;

  EnhanceScreen(this.image);

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  late img.Image inputImage;
  String results = "";
  @override
  void initState() {
    super.initState();
    inputImage = img.decodeImage(this.widget.image.readAsBytesSync())!;
  }

  enhanceImage() {
    inputImage = img.adjustColor(inputImage, brightness: 2);
    inputImage = img.contrast(inputImage, contrast: 150);
    setState(() {
      inputImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Image.memory(Uint8List.fromList(img.encodeBmp(inputImage))),
            Card(
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade300,
                child: Column(
                  children: [
                    Container(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.document_scanner,
                              color: Colors.white,
                            ),
                            Text(
                              "Kết quả",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: results));
                                SnackBar sn = SnackBar(content: Text("copied"));
                                ScaffoldMessenger.of(context).showSnackBar(sn);
                              },
                              child: Icon(
                                Icons.copy,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      results,
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
