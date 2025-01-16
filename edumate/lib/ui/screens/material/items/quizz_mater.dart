import 'package:edumate/ui/helpers/animation_route.dart';
import 'package:edumate/ui/screens/login/login_page.dart';
import 'package:edumate/ui/screens/material/items/quizz_group.dart';
import 'package:edumate/ui/screens/material/services/material_service.dart';
import 'package:edumate/ui/themes/styles/color.dart';
import 'package:flutter/material.dart';

class QuizManagementScreen extends StatefulWidget {
  @override
  _QuizManagementScreenState createState() => _QuizManagementScreenState();
}

class _QuizManagementScreenState extends State<QuizManagementScreen> {
  final QuizzService _apiService = QuizzService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _quizzes = [];
  List<dynamic> _groups = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
    _fetchGroups();
  }

  Future<void> _fetchQuizzes({int page = 1, String query = ''}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.fetchQuizzes(page: page, query: query);
      setState(() {
        _quizzes = response['data'];
        _currentPage = page;
        _totalPages = response['totalPages'];
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

  Future<void> _fetchGroups() async {
    try {
      final response = await _apiService.fetchGroups();
      setState(() {
        _groups = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch groups: $e'),
      ));
    }
  }

  Widget _buildQuizItem(dynamic quiz) {
    return GestureDetector(
      onDoubleTap: () {
        _showGroupModal(context, quiz['uuid']);
      },
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
      _fetchQuizzes(page: _currentPage);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                suffixIcon: Icon(Icons.search, color: Colors.green),
              ),
              onChanged: (value) {
                _fetchQuizzes(query: value); // Tìm kiếm khi nhập
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.green))
                : ListView.builder(
                    itemCount: _quizzes.length,
                    itemBuilder: (context, index) {
                      return _buildQuizItem(_quizzes[index]);
                    },
                  ),
          ),
          if (_totalPages > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: _currentPage > 1
                      ? () => _fetchQuizzes(page: _currentPage - 1)
                      : null,
                ),
                Text(
                  'Page $_currentPage of $_totalPages',
                  style: TextStyle(color: Colors.green),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.green),
                  onPressed: _currentPage < _totalPages
                      ? () => _fetchQuizzes(page: _currentPage + 1)
                      : null,
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showGroupModal(BuildContext context, String quizUuid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhóm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    return ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: Colors.green,
                      ),
                      title: Text(group["name"]),
                      trailing: Text(
                        group['count'].toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                      onLongPress: () {
                        Navigator.push(
                            context,
                            routeSlide(
                                page: QuizzByGroup(
                              groupId: group['uuid'],
                            )));
                      },
                      onTap: () async {
                        Navigator.pop(context);
                        final success = await _apiService.updateQuizGroup(
                          quizUuid,
                          group['uuid'],
                        );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Quiz added to group successfully!'),
                          ));
                          _fetchGroups();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to add quiz to group.'),
                          ));
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size.fromHeight(50), // Chiều cao nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(Icons.add),
                label: Text('Create New Category'),
                onPressed: () {
                  Navigator.pop(context); // Đóng modal
                  _showCreateGroupDialog(context, quizUuid);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateGroupDialog(BuildContext context, String quizUuid) {
    final TextEditingController groupNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Category'),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = groupNameController.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(context); // Đóng dialog
                  final success = await _apiService.createGroup(name);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Group created successfully!'),
                    ));
                    _fetchGroups();
                    _showGroupModal(context, quizUuid);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to create group.'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Category name cannot be empty.'),
                  ));
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
