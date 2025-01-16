// import 'package:edumate/ui/screens/flashcard/groups/groups.dart';
// import 'package:edumate/ui/screens/flashcard/public/flashcard_public.dart';
// import 'package:edumate/ui/widgets/widgets.dart';
// import 'package:flutter/material.dart';

// class FlashCardScreen extends StatefulWidget {
//   @override
//   _FlashCardScreenState createState() => _FlashCardScreenState();
// }

// class _FlashCardScreenState extends State<FlashCardScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const BottomNavigation(index: 4),
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text(
//           'FlashCard',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           tabs: [
//             Tab(text: 'Cá nhân'),
//             Tab(text: 'Cộng đồng'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           FlashcardGroupScreen(),
//           FlashcardPublicScreen(),
//         ],
//       ),
//     );
//   }

//   // Tab 1: Quiz Groups

//   // Tab 2: Flashcards

// // Widget for each Flashcard Topic Card
// }

import 'package:flutter/material.dart';
import 'package:edumate/ui/screens/flashcard/groups/groups.dart';
import 'package:edumate/ui/screens/flashcard/public/flashcard_public.dart';
import 'package:edumate/ui/widgets/widgets.dart';

class FlashCardScreen extends StatefulWidget {
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 4),
      backgroundColor: Colors.green.shade50, // Nền xanh lá nhạt
      appBar: AppBar(
        backgroundColor: Colors.green, // Màu xanh lá cây chủ đạo
        title: Text(
          'FlashCard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white, // Màu trắng cho tiêu đề
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white, // Màu chỉ báo tab
          labelColor: Colors.white, // Màu chữ tab được chọn
          unselectedLabelColor: Colors.white70, // Màu chữ tab chưa được chọn
          tabs: [
            Tab(text: 'Cá nhân'),
            Tab(text: 'Cộng đồng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FlashcardGroupScreen(),
          FlashcardPublicScreen(),
        ],
      ),
    );
  }
}
