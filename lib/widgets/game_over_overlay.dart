import 'package:flutter/material.dart';

/// Game over overlay widget
class GameOverOverlay extends StatelessWidget {
  final int score;
  final VoidCallback onPlayAgain;
  final VoidCallback? onLeaderboard;
  final bool isSmallScreen;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.onPlayAgain,
    this.onLeaderboard,
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
              const SizedBox(height: 8),
              Text(
                'Your score has been saved!',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: onPlayAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 20 : 28,
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    child: Text(
                      'Play Again',
                      style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                    ),
                  ),
                  if (onLeaderboard != null) ...[
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: onLeaderboard,
                      icon: const Icon(Icons.leaderboard, size: 18),
                      label: Text(
                        'Ranking',
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 24,
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
