import 'package:edumate/ui/screens/material/services/material_service.dart';
import 'package:flutter/material.dart';

class QuizzByGroup extends StatefulWidget {
  final String groupId;
  QuizzByGroup({required this.groupId});

  @override
  State<QuizzByGroup> createState() => _QuizzByGroupState();
}

class _QuizzByGroupState extends State<QuizzByGroup> {
  final QuizzService _apiService = new QuizzService();
  List<dynamic> _quizzes = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.fetchQuestionByGroup(widget.groupId);
      setState(() {
        _quizzes = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch quizzes: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[30],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Câu hỏi của nhóm"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : ListView.builder(
              itemCount: _quizzes.length,
              itemBuilder: (context, index) {
                return _buildQuizItem(_quizzes[index]);
              },
            ),
    );
  }

  Widget _buildQuizItem(dynamic quiz) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz['question'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 8),
              ...['ans_a', 'ans_b', 'ans_c', 'ans_d'].map((option) {
                return RadioListTile<String>(
                  value: quiz[option],
                  groupValue: quiz['result'],
                  activeColor: Colors.green,
                  title: Text(
                    quiz[option] ?? '',
                    style: TextStyle(color: Colors.black),
                  ),
                  onChanged: (value) {
                    setState(() {
                      quiz['result'] = value;
                    });
                    _updateQuiz(quiz['uuid'], value!);
                  },
                );
              }).toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      _showEditQuestionDialog(context, quiz);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteQuiz(quiz['uuid']),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateQuiz(String uuid, String result) async {
    final success = await _apiService.updateQuiz(uuid, {'result': result});
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Quiz updated successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update quiz'),
      ));
    }
  }

  Future<void> _deleteQuiz(String uuid) async {
    final success = await _apiService.deleteQuiz(uuid);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Quiz deleted successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete quiz'),
      ));
    }
  }

  void _showEditQuestionDialog(BuildContext context, dynamic quiz) {
    final TextEditingController questionController =
        TextEditingController(text: quiz['question']);
    final TextEditingController ansAController =
        TextEditingController(text: quiz['ans_a']);
    final TextEditingController ansBController =
        TextEditingController(text: quiz['ans_b']);
    final TextEditingController ansCController =
        TextEditingController(text: quiz['ans_c']);
    final TextEditingController ansDController =
        TextEditingController(text: quiz['ans_d']);
    final TextEditingController resultController =
        TextEditingController(text: quiz['result']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Question',
            style: TextStyle(color: Colors.green),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...[
                  {"label": "Question", "controller": questionController},
                  {"label": "Answer A", "controller": ansAController},
                  {"label": "Answer B", "controller": ansBController},
                  {"label": "Answer C", "controller": ansCController},
                  {"label": "Answer D", "controller": ansDController},
                  {"label": "Correct Answer", "controller": resultController},
                ].map((field) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      controller: field['controller'] as TextEditingController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: field['label'] as String,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                final updatedQuiz = {
                  'question': questionController.text.trim(),
                  'ans_a': ansAController.text.trim(),
                  'ans_b': ansBController.text.trim(),
                  'ans_c': ansCController.text.trim(),
                  'ans_d': ansDController.text.trim(),
                  'result': resultController.text.trim(),
                };

                final success = await _apiService.updateQuizDetail(
                    quiz['uuid'], updatedQuiz);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Question updated successfully!'),
                  ));
                  _fetchQuizzes();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to update question.'),
                  ));
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
