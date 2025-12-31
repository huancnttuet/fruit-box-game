import 'package:flutter/material.dart';

/// Game over overlay widget
class GameOverOverlay extends StatelessWidget {
  final int score;
  final VoidCallback onPlayAgain;
  final bool isSmallScreen;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.onPlayAgain,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '⏰ Time\'s Up!',
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Final Score: $score',
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onPlayAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 24 : 32,
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                ),
                child: Text(
                  'Play Again',
                  style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
