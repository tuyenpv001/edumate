import 'package:flutter/material.dart';
import 'color.dart';
import 'font.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: AppFonts.secondaryFont,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
