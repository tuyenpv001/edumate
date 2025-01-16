import 'package:edumate/ui/screens/material/services/material_service.dart';
import 'package:edumate/ui/screens/quizz/widgets/quizz_init.dart';
import 'package:flutter/material.dart';

class QuizGroupSelectionScreen extends StatefulWidget {
  @override
  _QuizGroupSelectionScreenState createState() =>
      _QuizGroupSelectionScreenState();
}

class _QuizGroupSelectionScreenState extends State<QuizGroupSelectionScreen> {
  final QuizzService _apiService = QuizzService();
  List<dynamic> quizGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizGroups();
  }

  Future<void> _loadQuizGroups() async {
    try {
      final groups = await _apiService.fetchGroups();
      setState(() {
        quizGroups = [
          {
            "uuid": "",
            "name": "Ngẫu nhiên",
            "public": 1,
            "user_uid": null,
            "count": 0
          }
        ];
        quizGroups.addAll(groups);
        isLoading = false;
      });
    } catch (e) {
      _showErrorSnackbar('Lỗi khi tải nhóm câu hỏi: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : quizGroups.isEmpty
              ? Center(
                  child: Text(
                    'Không có nhóm câu hỏi nào.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: quizGroups.length,
                    itemBuilder: (context, index) {
                      final group = quizGroups[index];
                      return _buildQuizGroupCard(group);
                    },
                  ),
                ),
    );
  }

  Widget _buildQuizGroupCard(dynamic group) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          group['name'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        subtitle: Text(
          'Số câu hỏi: ${group['count']}',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.green),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizInitScreen(groupId: group['uuid']),
            ),
          );
        },
      ),
    );
  }
}
