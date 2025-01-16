import 'package:edumate/ui/screens/quizz/widgets/quizz_detail.dart';
import 'package:edumate/ui/screens/quizz/widgets/quizz_group.dart';
import 'package:edumate/ui/screens/quizz/widgets/quizz_init.dart';
import 'package:edumate/ui/screens/quizz/widgets/quizz_select.dart';
import 'package:edumate/ui/themes/styles/color.dart';
import 'package:edumate/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({super.key});

  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomNavigation(index: 6),
        backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: Text(
            'Quizz',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: QuizGroupSelectionScreen());
  }
}
