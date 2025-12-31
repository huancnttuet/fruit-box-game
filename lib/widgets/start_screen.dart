import 'package:flutter/material.dart';
import '../constants/game_constants.dart';

/// Start screen widget shown before game begins
class StartScreen extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback? onLeaderboard;
  final bool isSmallScreen;

  const StartScreen({
    super.key,
    required this.onStart,
    this.onLeaderboard,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🍎🍏🍎', style: TextStyle(fontSize: isSmallScreen ? 48 : 64)),
            const SizedBox(height: 20),
            Text(
              'Fruit Box',
              style: TextStyle(
                fontSize: isSmallScreen ? 36 : 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Powered by Flame Engine 🔥',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select apples that add up to ${GameConstants.targetSum}!',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 32 : 48,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                textStyle: TextStyle(fontSize: isSmallScreen ? 18 : 24),
              ),
              child: const Text('Start Game'),
            ),
            if (onLeaderboard != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onLeaderboard,
                icon: const Icon(Icons.leaderboard, color: Colors.orange),
                label: Text(
                  'View Leaderboard',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
