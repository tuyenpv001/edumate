// import 'package:edumate/ui/themes/styles/logo.dart';
// import 'package:edumate/ui/widgets/widgets.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const BottomNavigation(index: 1),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: LogoWidget(
//           fontSize: 25,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications, color: Colors.blue),
//             onPressed: () {
//               // TODO: Open notifications
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Grid of Features
//             Text(
//               'Features',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               flex: 2,
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: 4, // Number of features
//                 itemBuilder: (context, index) {
//                   final featureColors = [
//                     Colors.blueAccent,
//                     Colors.greenAccent,
//                     Colors.pinkAccent,
//                     Colors.orangeAccent,
//                   ];
//                   final featureNames = [
//                     'Subjects',
//                     'Schedule',
//                     'Quizzes',
//                     'Notes & Docs'
//                   ];
//                   final featureIcons = [
//                     Icons.book,
//                     Icons.calendar_today,
//                     Icons.quiz,
//                     Icons.note,
//                   ];

//                   return GestureDetector(
//                     onTap: () {
//                       // TODO: Navigate to respective feature
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: featureColors[index],
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(featureIcons[index],
//                                 color: Colors.white, size: 40),
//                             Spacer(),
//                             Text(
//                               featureNames[index],
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             // On Going Section
//             Text(
//               'On Going',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Math Quiz Preparation',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Due: 25 Nov, 10:00 AM',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         const SizedBox(height: 16),
//                         // Progress Bar
//                         Container(
//                           height: 8,
//                           width: 200,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: FractionallySizedBox(
//                             widthFactor: 0.6, // 60% progress
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text('Progress: 60%',
//                             style: TextStyle(color: Colors.green)),
//                       ],
//                     ),
//                     Spacer(),
//                     Icon(Icons.access_time, color: Colors.orange, size: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Add new task
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }
import 'package:edumate/ui/helpers/animation_route.dart';
import 'package:edumate/ui/screens/flashcard/flashcard.dart';
import 'package:edumate/ui/screens/material/material.dart';
import 'package:edumate/ui/screens/note/note.dart';
import 'package:edumate/ui/screens/notification/items/note.dart';
import 'package:edumate/ui/screens/notification/notification_config.dart';
import 'package:edumate/ui/screens/quizz/quizz_list.dart';
import 'package:edumate/ui/themes/styles/logo.dart';
import 'package:edumate/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: LogoWidget(fontSize: 40),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.green),
            onPressed: () {
              // TODO: Open notifications
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Features Section**
            Text(
              'Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final featureColors = [
                    Colors.green[300]!,
                    Colors.green[400]!,
                    Colors.green[500]!,
                    Colors.green[600]!,
                  ];
                  final featureNames = [
                    'Ghi chú',
                    'Thông báo',
                    'Câu hỏi',
                    'Flashcard'
                  ];
                  final featureIcons = [
                    Icons.book,
                    Icons.calendar_today,
                    Icons.quiz,
                    Icons.note_alt_outlined,
                  ];

                  return GestureDetector(
                    onTap: () {
                      switch (index) {
                        case 0:
                          Navigator.pushAndRemoveUntil(context,
                              routeSlide(page: NotesScreen()), (_) => false);
                          break;
                        case 1:
                          Navigator.pushAndRemoveUntil(
                              context,
                              routeSlide(page: ReminderSettingsScreen()),
                              (_) => false);
                          break;
                        case 2:
                          Navigator.pushAndRemoveUntil(context,
                              routeSlide(page: QuizzScreen()), (_) => false);
                          break;
                        case 3:
                          Navigator.pushAndRemoveUntil(
                              context,
                              routeSlide(page: FlashCardScreen()),
                              (_) => false);
                          break;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: featureColors[index],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              featureIcons[index],
                              color: Colors.white,
                              size: 40,
                            ),
                            Spacer(),
                            Text(
                              featureNames[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // **News Feed Section**
            Text(
              'News Feed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: ListView(
                children: [
                  _buildNewsCard(
                    title: "Exam Schedule Released",
                    description:
                        "The final exam schedule for Semester 2 has been released. Check your timetable.",
                    icon: Icons.event_note,
                  ),
                  _buildNewsCard(
                    title: "New Quiz Added",
                    description: "A new quiz on Algebra has been added.",
                    icon: Icons.quiz,
                  ),
                  _buildNewsCard(
                    title: "Library Notice",
                    description:
                        "The library will be closed for maintenance on Friday, 10th Nov.",
                    icon: Icons.library_books,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new task
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
