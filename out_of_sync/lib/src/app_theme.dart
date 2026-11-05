part of '../main.dart';

class AppTheme {
  static const primaryColor = Color(0xFF007AFF);
  static const secondaryColor = Color(0xFF5856D6);
  static const backgroundColor = Color(0xFFF2F2F7);
  static const cardColor = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF8E8E93);
  static const destructiveColor = Color(0xFFFF3B30);
  static const successColor = Color(0xFF34C759);
  static const warningColor = Color(0xFFFF9500);
  
  static const borderRadius = 12.0;
  static const cardElevation = 0.0;
  static const spacing = 16.0;
  
  static const titleTextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const headlineTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const bodyTextStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );
  
  static const captionTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
}
