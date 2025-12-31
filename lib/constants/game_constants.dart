import 'package:flutter/material.dart';

/// Game configuration constants
class GameConstants {
  // Grid settings
  static const int gridRows = 10;
  static const int gridCols = 10;

  // Game rules
  static const int targetSum = 10;
  static const int gameDuration = 120; // seconds
  static const int warningTime = 30; // seconds remaining to show warning

  // Apple value range
  static const int minAppleValue = 1;
  static const int maxAppleValue = 9;

  // Prevent instantiation
  GameConstants._();
}

/// Color scheme for the game
class GameColors {
  // Primary colors
  static Color get primary => Colors.green.shade700;
  static Color get primaryLight => Colors.green.shade100;
  static Color get primaryLighter => Colors.green.shade50;
  static Color get primaryBorder => Colors.green.shade200;

  // Apple colors
  static Color get appleLight => Colors.red.shade300;
  static Color get appleDark => Colors.red.shade700;
  static Color get appleStem => Colors.brown.shade600;
  static Color get appleLeaf => Colors.green.shade600;

  // Selection colors
  static Color get selectionValid => Colors.green;
  static Color get selectionInvalid => Colors.blue;
  static Color get selectionHighlight => Colors.yellow;
  static Color get sumLabelValid => Colors.green;
  static Color get sumLabelInvalid => Colors.orange;

  // Background colors
  static const Color background = Color(0xFFF5F5DC);
  static const Color gameBackground = Color(0xFFE8F5E9);

  // Prevent instantiation
  GameColors._();
}
