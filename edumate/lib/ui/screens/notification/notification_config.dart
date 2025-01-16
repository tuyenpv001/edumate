// import 'package:edumate/ui/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:edumate/services/db_service.dart';
// import 'package:edumate/services/NotificationService.dart';

// class ReminderSettingsScreen extends StatefulWidget {
//   @override
//   _ReminderSettingsScreenState createState() => _ReminderSettingsScreenState();
// }

// class _ReminderSettingsScreenState extends State<ReminderSettingsScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _hoursController = TextEditingController();
//   final TextEditingController _minutesController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();
//   String _selectedType = 'general';
//   int? _selectedReferenceId;
//   String _filterType = 'note';
//   late TabController _tabController;
//   List<Map<String, dynamic>> _reminders = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     final validTypes = ['general', 'note', 'flashcard'];
//     if (!validTypes.contains(_selectedType)) {
//       _selectedType = 'general';
//     }
//     _loadReminders();
//   }

//   Future<void> _loadReminders() async {
//     final dbHelper = DBHelper();
//     final reminders = await dbHelper.getReminders();
//     setState(() {
//       _reminders = reminders;
//     });
//   }

//   Future<void> _deleteReminder(int id) async {
//     final dbHelper = DBHelper();
//     await dbHelper.deleteReminder(id);
//     await _loadReminders();
//   }

//   Future<void> _deleteAllReminders() async {
//     final dbHelper = DBHelper();
//     await dbHelper.deleteReminderAll();
//     await _loadReminders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const BottomNavigation(index: 5),
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           'Cài đặt thông báo',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           tabs: [
//             Tab(text: 'Cấu hình'),
//             Tab(text: 'Chi tiết'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildConfigureTab(),
//           _buildRemindersTab(),
//         ],
//       ),
//     );
//   }

//   Widget _buildConfigureTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Loại",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.green.shade800,
//             ),
//           ),
//           const SizedBox(height: 8),
//           DropdownButton<String>(
//             value: _selectedType,
//             isExpanded: true,
//             onChanged: (value) {
//               setState(() {
//                 _selectedType = value!;
//               });
//             },
//             items: [
//               DropdownMenuItem(
//                 value: 'general',
//                 child: Row(
//                   children: [
//                     Icon(Icons.notifications, color: Colors.green),
//                     const SizedBox(width: 8),
//                     Text('Nhắc nhở'),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'note',
//                 child: Row(
//                   children: [
//                     Icon(Icons.note, color: Colors.green),
//                     const SizedBox(width: 8),
//                     Text('Ghi chú'),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'flashcard',
//                 child: Row(
//                   children: [
//                     Icon(Icons.flash_on, color: Colors.green),
//                     const SizedBox(width: 8),
//                     Text('Flashcard'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Thời gian lặp",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.green.shade800,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _hoursController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.timer, color: Colors.green),
//                     labelText: 'Giờ',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: TextField(
//                   controller: _minutesController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.schedule, color: Colors.green),
//                     labelText: 'Phút',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Nhắc nhở",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.green.shade800,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: _messageController,
//             maxLines: 3,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.message, color: Colors.green),
//               labelText: 'Nội dung cho nhắc nhở',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () async {
//               final hours = int.tryParse(_hoursController.text) ?? 0;
//               final minutes = int.tryParse(_minutesController.text) ?? 0;
//               final message = _messageController.text;

//               if (hours == 0 && minutes == 0) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Vui lòng nhập thời gian hợp lệ!')),
//                 );
//                 return;
//               }

//               final dbHelper = DBHelper();
//               await dbHelper.insertReminder(
//                 type: _selectedType,
//                 referenceId: _selectedReferenceId,
//                 hours: hours,
//                 minutes: minutes,
//                 message: message,
//               );

//               final notificationService = NotificationService();
//               await notificationService.scheduleReminders();

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Thành công!')),
//               );
//               _hoursController.clear();
//               _minutesController.clear();
//               _messageController.clear();
//               _loadReminders();
//             },
//             icon: Icon(Icons.save, color: Colors.white),
//             label: Text('Lưu'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               minimumSize: Size(double.infinity, 48),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: () async {
//               await _deleteAllReminders();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Tất cả lịch lặp hủy thành công!')),
//               );
//             },
//             icon: Icon(Icons.cancel, color: Colors.white),
//             label: Text('Hủy'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               minimumSize: Size(double.infinity, 48),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRemindersTab() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: DropdownButton<String>(
//             value: _filterType,
//             isExpanded: true,
//             onChanged: (value) {
//               setState(() {
//                 _filterType = value!;
//                 _loadFilteredItems();
//               });
//             },
//             items: [
//               DropdownMenuItem(value: 'note', child: Text('Ghi chú')),
//               DropdownMenuItem(value: 'flashcard', child: Text('Flashcards')),
//               DropdownMenuItem(value: 'general', child: Text('Nhắc nhở')),
//             ],
//           ),
//         ),
//         const Divider(height: 1, color: Colors.grey),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _reminders.length,
//             itemBuilder: (context, index) {
//               final item = _reminders[index];
//               return ListTile(
//                 leading: Icon(
//                   _filterType == 'note' ? Icons.note : Icons.flash_on,
//                   color: Colors.green,
//                 ),
//                 title: Text(
//                     _filterType == 'note' ? item['title'] : item['answer']),
//                 subtitle: Text(
//                   _filterType == 'note' ? item['content'] : item['question'],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     await _deleteItem(item['id']);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                           content: Text(
//                               '${_filterType == 'note' ? 'Ghi chú' : 'Flashcard'} đã xóa!')),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _loadFilteredItems() async {
//     final dbHelper = DBHelper();
//     List<Map<String, dynamic>> items;
//     if (_filterType == 'note') {
//       items = await dbHelper.getNotes();
//     } else if (_filterType == 'flashcard') {
//       items = await dbHelper.getFlashcard();
//     } else {
//       items = [];
//     }

//     setState(() {
//       _reminders = items;
//     });
//   }

//   Future<void> _deleteItem(int id) async {
//     final dbHelper = DBHelper();
//     if (_filterType == 'note') {
//       await dbHelper.deleteNoteId(id);
//     } else if (_filterType == 'flashcard') {
//       await dbHelper.deleteFlashcardId(id);
//     }
//     await _loadFilteredItems();
//   }
// }

import 'package:edumate/ui/screens/notification/items/flashcard.dart';
import 'package:edumate/ui/screens/notification/items/note.dart';
import 'package:edumate/ui/screens/notification/items/reminder.dart';
import 'package:edumate/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:edumate/services/db_service.dart';
import 'package:edumate/services/NotificationService.dart';

class ReminderSettingsScreen extends StatefulWidget {
  @override
  _ReminderSettingsScreenState createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedType = 'general';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 5),
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Cài đặt thông báo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Nhắc nhở'),
            Tab(text: 'Ghi chú'),
            Tab(text: 'Flashcards'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ReminderScreen(),
          Note(),
          Flashcard(),
        ],
      ),
    );
  }
}
