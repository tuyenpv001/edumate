import 'package:edumate/ui/screens/quizz/widgets/quizz_screen.dart';
import 'package:flutter/material.dart';

class QuizInitScreen extends StatefulWidget {
  final String groupId;

  QuizInitScreen({required this.groupId});

  @override
  _QuizInitScreenState createState() => _QuizInitScreenState();
}

class _QuizInitScreenState extends State<QuizInitScreen> {
  final TextEditingController questionCountController = TextEditingController();
  final TextEditingController timeLimitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: Text(
          'Thiết lập Quiz',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thiết lập',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 20),
              _buildInputField(
                controller: questionCountController,
                label: 'Số câu hỏi',
                hint: 'Enter the number of questions',
                icon: Icons.question_mark,
              ),
              SizedBox(height: 15),
              _buildInputField(
                controller: timeLimitController,
                label: 'Thời gian (phút)',
                hint: 'Enter the time limit',
                icon: Icons.timer,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  final questionCount =
                      int.tryParse(questionCountController.text);
                  final timeLimit = int.tryParse(timeLimitController.text);

                  if (questionCount == null || timeLimit == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter valid numbers!'),
                    ));
                    return;
                  }
                  if (questionCount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Vui lòng nhập số lượng câu hỏi!'),
                    ));
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                          questionCount: questionCount,
                          timeLimit: timeLimit,
                          groupId: this.widget.groupId),
                    ),
                  );
                },
                icon: Icon(Icons.play_arrow),
                label: Text('Bắt đầu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
