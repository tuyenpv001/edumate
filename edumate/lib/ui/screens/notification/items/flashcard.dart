import 'package:edumate/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:edumate/services/db_service.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({super.key});

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  final notificationService = NotificationService();
//               await notificationService.scheduleReminders();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String _selectedRepeatType = 'interval'; // Default repeat type
  TimeOfDay? _selectedFixedTime;
  List<Map<String, dynamic>> _flashcards = [];
  final DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final flashcards = await dbHelper.getFlashcard();
    setState(() {
      _flashcards = flashcards;
    });
  }

  Future<void> _addFlashcard() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Câu hỏi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Đáp án',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final question = _questionController.text.trim();
                final answer = _answerController.text.trim();

                if (title.isNotEmpty &&
                    question.isNotEmpty &&
                    answer.isNotEmpty) {
                  await dbHelper.insertFlashcard(
                    title: title,
                    question: question,
                    answer: answer,
                  );
                  _loadFlashcards();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thêm thành công!')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng nhập đầy đủ thông tin!')),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfigSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cấu hình thông báo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Loại lặp lại',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            title: const Text('Lặp lại theo giờ cố định'),
            value: 'fixed',
            groupValue: _selectedRepeatType,
            onChanged: (value) {
              setState(() {
                _selectedRepeatType = value!;
              });
            },
          ),
          if (_selectedRepeatType == 'fixed') ...[
            GestureDetector(
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedFixedTime = pickedTime;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedFixedTime != null
                          ? _selectedFixedTime!.format(context)
                          : 'Chọn giờ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.access_time, color: Colors.green),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          RadioListTile<String>(
            title: const Text('Tự động lặp lại sau khoảng thời gian'),
            value: 'interval',
            groupValue: _selectedRepeatType,
            onChanged: (value) {
              setState(() {
                _selectedRepeatType = value!;
              });
            },
          ),
          if (_selectedRepeatType == 'interval') ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Giờ',
                      border: OutlineInputBorder(),
                      prefixIcon:
                          Icon(Icons.hourglass_empty, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Phút',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              if (_selectedRepeatType == 'fixed') {
                final fixedTime = _selectedFixedTime?.format(context);
                if (fixedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng chọn giờ cố định!')),
                  );
                  return;
                }

                await dbHelper.insertOrUpdateConfig(
                  type: 'flashcard',
                  repeatTime: fixedTime,
                  intervalHours: null,
                  intervalMinutes: null,
                );
              } else if (_selectedRepeatType == 'interval') {
                await dbHelper.insertOrUpdateConfig(
                  type: 'flashcard',
                  repeatTime: null,
                  intervalHours: int.tryParse(_hoursController.text) ?? 0,
                  intervalMinutes: int.tryParse(_minutesController.text) ?? 0,
                );
              }

              await notificationService.scheduleReminders();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lưu thành công!')),
              );
            },
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('Lưu cấu hình'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = _flashcards[index];
          return ListTile(
            leading: const Icon(Icons.flash_on, color: Colors.orange),
            title: Text(flashcard['title']),
            subtitle: Text(
              flashcard['question'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await dbHelper.deleteFlashcard(flashcard['id']);
                _loadFlashcards();
                await notificationService.scheduleReminderSpecial();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Xóa thành công!')),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildConfigSection(),
        const SizedBox(height: 16),
        _buildFlashcardList(),
      ],
    );
  }
}
