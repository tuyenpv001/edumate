import 'package:edumate/services/NotificationService.dart';
import 'package:edumate/services/db_service.dart';
import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final notificationService = NotificationService();
  String _selectedRepeatType = 'fixed';
  TimeOfDay? _selectedFixedTime;

  final TextEditingController _repeatTimeController = TextEditingController();
  final TextEditingController _intervalHoursController =
      TextEditingController();
  final TextEditingController _intervalMinutesController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  List<Map<String, dynamic>> _notes = [];
  int _currentPage = 1;
  int _itemsPerPage = 10;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadConfig();
    _loadNotes();
  }

  Future<void> _loadConfig() async {
    final config = await _dbHelper.getConfigByType('note');
    if (config != null) {
      setState(() {
        if (config != null) {
          // Lặp theo giờ cố định
          if (config['repeat_time'] != null) {
            _selectedRepeatType = 'fixed';
            final timeParts = config['repeat_time'].split(':');
            final hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);
            _selectedFixedTime = TimeOfDay(hour: hour, minute: minute);
          }

          // Lặp theo khoảng thời gian
          if (config['interval_hours'] != null ||
              config['interval_minutes'] != null) {
            _selectedRepeatType = 'interval';
            _intervalHoursController.text =
                config['interval_hours']?.toString() ?? '0';
            _intervalMinutesController.text =
                config['interval_minutes']?.toString() ?? '0';
          }
        }
      });
    }
  }

  Future<void> _saveConfig() async {
    if (_selectedRepeatType == 'fixed') {
      final fixedTime = _selectedFixedTime?.format(context);
      if (fixedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn giờ cố định!')),
        );
        return;
      }

      await _dbHelper.insertOrUpdateConfig(
        type: 'note',
        repeatTime: fixedTime,
        intervalHours: null,
        intervalMinutes: null,
      );
    } else if (_selectedRepeatType == 'interval') {
      await _dbHelper.insertOrUpdateConfig(
        type: 'note',
        repeatTime: null,
        intervalHours: int.tryParse(_intervalHoursController.text) ?? 0,
        intervalMinutes: int.tryParse(_intervalMinutesController.text) ?? 0,
      );
    }
    await notificationService.scheduleReminders();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cấu hình thông báo đã được lưu!')));
  }

  Future<void> _loadNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes
          .where((note) =>
              _searchQuery.isEmpty ||
              note['title']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              note['content']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .skip((_currentPage - 1) * _itemsPerPage)
          .take(_itemsPerPage)
          .toList();
    });
  }

  Future<void> _deleteNoteById(int id) async {
    await _dbHelper.deleteNoteId(id);
    _loadNotes();
    await notificationService.scheduleReminderSpecial();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Ghi chú đã được xóa!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildConfigSection(),
            const SizedBox(height: 16),
            _buildNotesSection(),
          ],
        ),
      ),
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
          Text(
            'Loại lặp lại',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            title: Text('Lặp lại theo giờ cố định'),
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
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.access_time, color: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          RadioListTile<String>(
            title: Text('Tự động lặp lại sau khoảng thời gian'),
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
                    controller: _intervalHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
                    controller: _intervalMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phút',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity, // Full width cho nút
            child: ElevatedButton.icon(
              onPressed: _saveConfig,
              icon: Icon(Icons.save, color: Colors.white),
              label: Text('Lưu cấu hình'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tìm kiếm
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Tìm kiếm',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search, color: Colors.green),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _currentPage = 1;
                _loadNotes();
              });
            },
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              final note = _notes[index];
              return ListTile(
                leading: Icon(Icons.note, color: Colors.blue),
                title: Text(note['title']),
                subtitle: Text(
                  note['content'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteNoteById(note['id']),
                ),
              );
            },
          ),

          // Phân trang
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                    _loadNotes();
                  });
                }
              : null,
        ),
        Text('Trang $_currentPage'),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: (_notes.length == _itemsPerPage)
              ? () {
                  setState(() {
                    _currentPage++;
                    _loadNotes();
                  });
                }
              : null,
        ),
      ],
    );
  }
}
