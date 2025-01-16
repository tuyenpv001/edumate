import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:edumate/ui/screens/scans/items/EnhanceScreen.dart';
import 'package:edumate/ui/screens/scans/items/RecognizerScreen.dart';
import 'package:edumate/ui/screens/scans/items/ScannerScreen.dart';
import 'package:edumate/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late ImagePicker imagePicker;
  late List<CameraDescription> _cameras;
  late CameraController controller;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    initCamera();
  }

  bool isInit = false;
  Future<void> initCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller
        .initialize()
        .then((_) => {
              if (!mounted)
                {}
              else
                {
                  setState(() {
                    isInit = true;
                  })
                }
            })
        // ignore: body_might_complete_normally_catch_error
        .catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case "CameraAccessDenied":
            break;
          default:
            break;
        }
      }
    });
  }

  bool scan = false;
  bool recognize = false;
  bool enhance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 7),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 50, bottom: 15, left: 5, right: 5),
        child: Column(children: [
          Card(
            color: Colors.green,
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.scanner,
                          size: 30,
                          color: scan ? Colors.black : Colors.white,
                        ),
                        Text(
                          "Scan",
                          style: TextStyle(
                              color: scan ? Colors.black : Colors.white),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = true;
                        recognize = false;
                        enhance = false;
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.document_scanner,
                          size: 30,
                          color: recognize ? Colors.black : Colors.white,
                        ),
                        Text("recog",
                            style: TextStyle(
                                color: recognize ? Colors.black : Colors.white))
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = false;
                        recognize = true;
                        enhance = false;
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 30,
                          color: enhance ? Colors.black : Colors.white,
                        ),
                        Text("Enhance",
                            style: TextStyle(
                                color: enhance ? Colors.black : Colors.white))
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = false;
                        recognize = false;
                        enhance = true;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.black,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 400,
                    child: isInit
                        ? AspectRatio(
                            child: CameraPreview(controller),
                            aspectRatio: controller.value.aspectRatio,
                          )
                        : Container(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(20),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .moveY(
                        begin: 0,
                        end: MediaQuery.of(context).size.height - 400,
                        duration: 2000.ms)
              ],
            ),
          ),
          Card(
            color: Colors.green,
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.rotate_left,
                      size: 50,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.camera,
                      size: 50,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      await controller.takePicture().then((value) {
                        if (value != null) {
                          File image = File(value.path);
                          proccessImage(image);
                        }
                      });
                    },
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      print("gallery");
                      XFile? xFile = await imagePicker.pickImage(
                          source: ImageSource.gallery);

                      if (xFile != null) {
                        File image = File(xFile.path);
                        proccessImage(image);
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  proccessImage(File image) async {
    final editImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(image: image.readAsBytesSync()),
        ));
    image.writeAsBytes(editImage);

    if (recognize) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return RecognizerScreen(image);
        },
      ));
    } else if (scan) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return ScannerScreen(image);
        },
      ));
    } else if (enhance) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return EnhanceScreen(image);
        },
      ));
    }
  }
}

// import 'dart:io';
// import 'dart:math';

// import 'package:camera/camera.dart';
// import 'package:edumate/ui/screens/scans/items/EnhanceScreen.dart';
// import 'package:edumate/ui/screens/scans/items/RecognizerScreen.dart';
// import 'package:edumate/ui/screens/scans/items/ScannerScreen.dart';
// import 'package:edumate/ui/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';
// import 'package:image_picker/image_picker.dart';

// class ScanScreen extends StatefulWidget {
//   const ScanScreen({super.key});

//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }

// class _ScanScreenState extends State<ScanScreen> {
//   late ImagePicker imagePicker;
//   late List<CameraDescription> _cameras;
//   late CameraController controller;
//   bool isInit = false;

//   bool scan = false;
//   bool recognize = false;
//   bool enhance = false;

//   @override
//   void initState() {
//     super.initState();
//     imagePicker = ImagePicker();
//     initCamera();
//   }

//   Future<void> initCamera() async {
//     _cameras = await availableCameras();
//     controller = CameraController(_cameras[0], ResolutionPreset.max);
//     await controller.initialize();
//     if (mounted) {
//       setState(() {
//         isInit = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     //  controller.dispose(); // Tắt camera khi màn hình bị hủy
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const BottomNavigation(index: 7),
//       body: Container(
//         color: Colors.green.shade50,
//         padding: const EdgeInsets.only(top: 50, bottom: 15, left: 5, right: 5),
//         child: Column(
//           children: [
//             // Top Bar
//             Card(
//               color: Colors.green,
//               child: Container(
//                 height: 100,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildOptionButton(
//                       icon: Icons.scanner,
//                       label: "Scan",
//                       isSelected: scan,
//                       onTap: () {
//                         setState(() {
//                           scan = true;
//                           recognize = false;
//                           enhance = false;
//                         });
//                       },
//                     ),
//                     _buildOptionButton(
//                       icon: Icons.document_scanner,
//                       label: "Recog",
//                       isSelected: recognize,
//                       onTap: () {
//                         setState(() {
//                           scan = false;
//                           recognize = true;
//                           enhance = false;
//                         });
//                       },
//                     ),
//                     _buildOptionButton(
//                       icon: Icons.assignment,
//                       label: "Enhance",
//                       isSelected: enhance,
//                       onTap: () {
//                         setState(() {
//                           scan = false;
//                           recognize = false;
//                           enhance = true;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Camera Preview
//             Card(
//               color: Colors.black,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height - 400,
//                       child: isInit
//                           ? AspectRatio(
//                               child: CameraPreview(controller),
//                               aspectRatio: controller.value.aspectRatio,
//                             )
//                           : Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                     ),
//                   ),
//                   // Animated Scanner Line
//                   Container(
//                     color: Colors.white,
//                     height: 2,
//                     width: MediaQuery.of(context).size.width,
//                     margin: const EdgeInsets.all(20),
//                   )
//                       .animate(
//                         onPlay: (controller) => controller.repeat(),
//                       )
//                       .moveY(
//                           begin: 0,
//                           end: MediaQuery.of(context).size.height - 400,
//                           duration: 2000.ms),
//                 ],
//               ),
//             ),
//             // Bottom Bar
//             Card(
//               color: Colors.green,
//               child: Container(
//                 height: 100,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildActionButton(
//                       icon: Icons.rotate_left,
//                       onTap: () {},
//                     ),
//                     _buildActionButton(
//                       icon: Icons.camera,
//                       onTap: () async {
//                         await controller.takePicture().then((value) {
//                           if (value != null) {
//                             File image = File(value.path);
//                             proccessImage(image);
//                           }
//                         });
//                       },
//                     ),
//                     _buildActionButton(
//                       icon: Icons.image_outlined,
//                       onTap: () async {
//                         XFile? xFile = await imagePicker.pickImage(
//                             source: ImageSource.gallery);

//                         if (xFile != null) {
//                           File image = File(xFile.path);
//                           proccessImage(image);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionButton({
//     required IconData icon,
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 30,
//             color: isSelected ? Colors.black : Colors.white,
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.black : Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Icon(
//         icon,
//         size: 50,
//         color: Colors.white,
//       ),
//     );
//   }

//   proccessImage(File image) async {
//     controller.dispose(); // Tắt camera trước khi chuyển màn hình
//     final editImage = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ImageCropper(image: image.readAsBytesSync()),
//       ),
//     );
//     image.writeAsBytes(editImage);

//     if (recognize) {
//       Navigator.push(context, MaterialPageRoute(
//         builder: (context) {
//           return RecognizerScreeen(image);
//         },
//       ));
//     } else if (scan) {
//       Navigator.push(context, MaterialPageRoute(
//         builder: (context) {
//           return ScannerScreen(image);
//         },
//       ));
//     } else if (enhance) {
//       Navigator.push(context, MaterialPageRoute(
//         builder: (context) {
//           return EnhanceScreen(image);
//         },
//       ));
//     }
//   }
// }
