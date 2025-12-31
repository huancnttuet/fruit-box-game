import 'package:flutter/material.dart';
import '../constants/game_constants.dart';

/// Header widget showing score and timer
class GameHeader extends StatelessWidget {
  final int score;
  final int timeLeft;
  final VoidCallback onReset;
  final bool isSmallScreen;

  const GameHeader({
    super.key,
    required this.score,
    required this.timeLeft,
    required this.onReset,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
      color: GameColors.primary,
      child: Column(
        children: [
          _buildTitleRow(),
          const SizedBox(height: 8),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '🍎 Fruit Box',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          color: Colors.white,
          tooltip: 'Reset',
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final isWarning = timeLeft <= GameConstants.warningTime;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatBadge('Score: $score', Colors.white, GameColors.primary),
        SizedBox(width: isSmallScreen ? 12 : 16),
        _buildStatBadge(
          '⏱️ ${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}',
          isWarning ? Colors.red : Colors.white,
          isWarning ? Colors.white : GameColors.primary,
        ),
      ],
    );
  }

  Widget _buildStatBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
