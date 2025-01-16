import 'dart:async';
import 'package:flutter/material.dart';
import 'package:edumate/ui/screens/material/services/material_service.dart';
import 'package:edumate/ui/screens/quizz/widgets/quizz_quest.dart';
import 'package:edumate/ui/screens/quizz/widgets/quizz_result.dart';

class QuizScreen extends StatefulWidget {
  final int questionCount;
  final int timeLimit;
  final String groupId;

  QuizScreen(
      {required this.questionCount,
      required this.timeLimit,
      required this.groupId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizzService _apiService = QuizzService();
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  Map<int, String> _answers = {}; // Lưu đáp án đã chọn của người dùng
  bool _isLoading = true;

  Timer? _timer;
  late ValueNotifier<int> _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = ValueNotifier(widget.timeLimit * 60);
    _fetchQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remainingTime.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime.value > 0) {
        _remainingTime.value--;
      } else {
        _timer?.cancel();
        _submitQuiz();
      }
    });
  }

  Future<void> _fetchQuestions() async {
    try {
      final response = await _apiService.fetchRandomQuestions(
          widget.questionCount, widget.groupId);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('KHông có câu hỏi phù hợp'),
        ));
        return;
      }

      setState(() {
        _questions = response;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load questions: $e'),
      ));
    }
  }

  void _submitQuiz() {
    int correct = 0;
    List<Map<String, dynamic>> incorrectQuestions = [];

    // for (int i = 0; i < _questions.length; i++) {
    //   if (_answers[i] == _questions[i]['result']) {
    //     correct++;
    //   }
    // }
    for (int i = 0; i < _questions.length; i++) {
      final correctAnswer = _questions[i]['result'];
      final userAnswer = _answers[i];

      if (userAnswer == correctAnswer) {
        correct++;
      } else {
        // Lưu câu sai vào danh sách
        incorrectQuestions.add({
          'question': _questions[i]['question'], // Nội dung câu hỏi
          'correctAnswer': correctAnswer, // Đáp án đúng
          'userAnswer': userAnswer, // Đáp án người dùng chọn
          'options': _questions[i]
              .entries
              .where((entry) =>
                  entry.key.startsWith('ans') &&
                  entry.value != null) // Các lựa chọn
              .map((entry) => entry.value)
              .toList(),
        });
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
            totalQuestions: _questions.length,
            correctAnswers: correct,
            wrongAnswers: _questions.length - correct,
            incorrectQuestions: incorrectQuestions),
      ),
    );
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Colors.green,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green.shade50, // Màu nền
      appBar: AppBar(
        title: Text('Quiz'),
        centerTitle: true,
        backgroundColor: Colors.green, // Màu chính
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: _remainingTime,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _formatTime(value),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Hiển thị câu hỏi
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nội dung câu hỏi
                      Text(
                        _questions[_currentQuestionIndex]['question'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: 20),
                      // Lựa chọn đáp án
                      ..._questions[_currentQuestionIndex]
                          .entries
                          .where((entry) =>
                              entry.key.startsWith('ans') &&
                              entry.value != null)
                          .map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _answers[_currentQuestionIndex] = entry.value;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _answers[_currentQuestionIndex] ==
                                        entry.value
                                    ? Colors.green.shade100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Nút điều hướng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex > 0
                      ? () => setState(() {
                            _currentQuestionIndex--;
                          })
                      : null,
                  child: Text('Trước'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _currentQuestionIndex < _questions.length - 1
                      ? () => setState(() {
                            _currentQuestionIndex++;
                          })
                      : null,
                  child: Text('Tiếp theo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Nút nộp bài
            ElevatedButton(
              onPressed: _submitQuiz,
              child: Text('Hoàn thành'),
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
    );
  }
}
