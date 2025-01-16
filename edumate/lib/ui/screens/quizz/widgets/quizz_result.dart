import 'package:edumate/ui/screens/quizz/widgets/quizz_group.dart';
import 'package:edumate/ui/screens/quizz/widgets/quizz_incorrect.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final List<Map<String, dynamic>> incorrectQuestions;
  ResultScreen(
      {required this.totalQuestions,
      required this.correctAnswers,
      required this.wrongAnswers,
      required this.incorrectQuestions});

  @override
  Widget build(BuildContext context) {
    double scorePercentage =
        (correctAnswers / totalQuestions) * 100; // Tính phần trăm điểm

    // Xác định trạng thái (High Score, Average, Low Score)
    String message;
    IconData icon;
    Color color;

    if (scorePercentage >= 70) {
      message = 'Tuyệt vời!';
      icon = Icons.emoji_events;
      color = Colors.green;
    } else if (scorePercentage >= 50) {
      message = 'Không tệ!';
      icon = Icons.sentiment_neutral;
      color = Colors.orange;
    } else {
      message = 'Chúc bạn lần sau!';
      icon = Icons.sentiment_dissatisfied;
      color = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả'),
        centerTitle: true,
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon thể hiện trạng thái điểm
            Icon(
              icon,
              size: 100,
              color: color,
            ),
            SizedBox(height: 20),
            // Text hiển thị thông điệp dựa trên điểm số
            Text(
              message,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your Performance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30),
            // Thông tin chi tiết kết quả
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow(
                      'Tổng câu hỏi:',
                      totalQuestions.toString(),
                      Icons.quiz,
                      Colors.blue,
                    ),
                    SizedBox(height: 10),
                    _buildResultRow(
                      'Số câu đúng:',
                      correctAnswers.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IncorrectScreen(
                              incorrectQuestions: incorrectQuestions,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.cancel, color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Số câu sai:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            wrongAnswers.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 1),
                    _buildResultRow(
                      'Tỷ lệ:',
                      '${scorePercentage.toStringAsFixed(1)}%',
                      Icons.percent,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Nút quay lại trang chủ
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizGroupSelectionScreen()),
                );
              },
              icon: Icon(Icons.home),
              label: Text('Quay lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
      String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
