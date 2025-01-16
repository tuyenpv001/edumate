import 'package:edumate/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:edumate/services/db_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final notificationService = NotificationService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedRepeatType = 'fixed';
  TimeOfDay? _selectedFixedTime;
  final TextEditingController _intervalHoursController =
      TextEditingController();
  final TextEditingController _intervalMinutesController =
      TextEditingController();

  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReminderForm(),
            const SizedBox(height: 16),
            _buildReminderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Tiêu đề',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.title, color: Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: 'Nội dung',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.note, color: Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loại lặp lại',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
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
          if (_selectedRepeatType == 'fixed')
            GestureDetector(
              onTap: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedFixedTime ?? TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedFixedTime = pickedTime;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
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
          if (_selectedRepeatType == 'interval')
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _intervalHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Giờ',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.hourglass_empty,
                          color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _intervalMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phút',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.timer, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(
            height: 16,
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveReminder,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Lưu nhắc nhở'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildReminderList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getReminders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có nhắc nhở nào.'));
        }
        final reminders = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return ListTile(
              leading: const Icon(Icons.notifications, color: Colors.green),
              title: Text(reminder['title']),
              subtitle: Text(
                reminder['content'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await dbHelper.deleteReminder(reminder['id']);
                  setState(() {});
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveReminder() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final repeatType = _selectedRepeatType;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề!')),
      );
      return;
    }

    if (repeatType == 'fixed' && _selectedFixedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn giờ cố định!')),
      );
      return;
    }

    if (repeatType == 'interval' &&
        (_intervalHoursController.text.isEmpty &&
            _intervalMinutesController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập khoảng thời gian lặp!')),
      );
      return;
    }

    await dbHelper.insertReminder(
      title: title,
      content: content,
      repeatType: repeatType,
      fixedTime: _selectedFixedTime?.format(context),
      intervalHours: int.tryParse(_intervalHoursController.text) ?? 0,
      intervalMinutes: int.tryParse(_intervalMinutesController.text) ?? 0,
    );

    _titleController.clear();
    _contentController.clear();
    _selectedFixedTime = null;
    _intervalHoursController.clear();
    _intervalMinutesController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lưu nhắc nhở thành công!')),
    );
    await notificationService.scheduleReminderSpecial();
    setState(() {});
  }
}
