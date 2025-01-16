// import 'package:flutter/material.dart';

// class IncorrectScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> incorrectQuestions;

//   IncorrectScreen({required this.incorrectQuestions});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text(
//           'Câu sai',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         itemCount: incorrectQuestions.length,
//         padding: EdgeInsets.all(16),
//         itemBuilder: (context, index) {
//           final question = incorrectQuestions[index];
//           final correctAnswer = question['correctAnswer'];
//           final userAnswer = question['userAnswer'];
//           final options = question['options'];

//           return Card(
//             margin: EdgeInsets.only(bottom: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Câu ${index + 1}: ${question['question']}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Column(
//                     children: options.map<Widget>((option) {
//                       final isCorrect = option == correctAnswer;
//                       final isSelected = option == userAnswer;

//                       return Container(
//                         margin: EdgeInsets.only(bottom: 8),
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isCorrect
//                               ? Colors.green.withOpacity(0.2)
//                               : isSelected
//                                   ? Colors.red.withOpacity(0.2)
//                                   : Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             if (isCorrect)
//                               Icon(Icons.check, color: Colors.green),
//                             if (isSelected && !isCorrect)
//                               Icon(Icons.close, color: Colors.red),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 option,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: isCorrect
//                                       ? Colors.green
//                                       : isSelected
//                                           ? Colors.red
//                                           : Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class IncorrectScreen extends StatelessWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  IncorrectScreen({required this.incorrectQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách câu sai'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: incorrectQuestions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      size: 80,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Thật tuyệt vời! Bạn đã trả lời đúng tất cả các câu hỏi! 🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: incorrectQuestions.length,
                itemBuilder: (context, index) {
                  final question = incorrectQuestions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Câu hỏi ${index + 1}: ${question['question']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...question['options'].map<Widget>((option) {
                            final isCorrect =
                                option == question['correctAnswer'];
                            final isUserAnswer =
                                option == question['userAnswer'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isCorrect
                                      ? Colors.green.shade100
                                      : isUserAnswer
                                          ? Colors.red.shade100
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isCorrect
                                        ? Colors.green
                                        : isUserAnswer
                                            ? Colors.red
                                            : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCorrect
                                        ? Colors.green.shade700
                                        : isUserAnswer
                                            ? Colors.red.shade700
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
