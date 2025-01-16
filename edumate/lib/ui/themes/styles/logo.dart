import 'package:flutter/material.dart';
import 'package:edumate/ui/themes/styles/color.dart';

class LogoWidget extends StatelessWidget {
  final double fontSize;

  const LogoWidget({Key? key, this.fontSize = 40.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
        children: const [
          TextSpan(
            text: 'edu',
            style: TextStyle(color: AppColors.primary),
          ),
          TextSpan(
            text: 'Mate',
            style: TextStyle(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
