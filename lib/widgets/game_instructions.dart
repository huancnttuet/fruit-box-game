import 'package:flutter/material.dart';
import '../constants/game_constants.dart';

/// Instructions bar widget
class GameInstructions extends StatelessWidget {
  final bool isSmallScreen;

  const GameInstructions({super.key, required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 4 : 8,
        horizontal: 16,
      ),
      color: GameColors.primaryLight,
      child: Text(
        isSmallScreen
            ? 'Select apples that sum to ${GameConstants.targetSum}!'
            : 'Drag to select apples that sum to exactly ${GameConstants.targetSum}. Each apple collected = 1 point!',
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
