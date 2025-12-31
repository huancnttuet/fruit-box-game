import 'package:flutter/material.dart';
import '../constants/game_constants.dart';
import '../models/score_entry.dart';
import '../services/leaderboard_service.dart';

/// Leaderboard screen showing top scores
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<ScoreEntry> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await LeaderboardService.getScores();
    setState(() {
      _scores = scores;
      _isLoading = false;
    });
  }

  // Future<void> _clearScores() async {
  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Clear Leaderboard'),
  //       content: const Text('Are you sure you want to clear all scores?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           style: TextButton.styleFrom(foregroundColor: Colors.red),
  //           child: const Text('Clear'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirm == true) {
  //     await LeaderboardService.clearLocalScores();
  //     _loadScores();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        title: const Text('🏆 Leaderboard'),
        backgroundColor: GameColors.primary,
        foregroundColor: Colors.white,
        actions: [
          // if (_scores.isNotEmpty)
          //   IconButton(
          //     icon: const Icon(Icons.delete_outline),
          //     onPressed: _clearScores,
          //     tooltip: 'Clear Leaderboard',
          //   ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scores.isEmpty
          ? _buildEmptyState(isSmallScreen)
          : _buildLeaderboardList(isSmallScreen),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: isSmallScreen ? 80 : 120,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No scores yet!',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Play a game to get on the leaderboard',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(bool isSmallScreen) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scores.length,
      itemBuilder: (context, index) {
        final entry = _scores[index];
        final rank = index + 1;
        return _buildScoreCard(entry, rank, isSmallScreen);
      },
    );
  }

  Widget _buildScoreCard(ScoreEntry entry, int rank, bool isSmallScreen) {
    final isTopThree = rank <= 3;
    final rankColors = {
      1: Colors.amber.shade600,
      2: Colors.grey.shade400,
      3: Colors.brown.shade400,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isTopThree ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isTopThree
            ? BorderSide(
                color: rankColors[rank] ?? Colors.transparent,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Row(
          children: [
            // Rank badge
            _buildRankBadge(rank, isSmallScreen),
            SizedBox(width: isSmallScreen ? 12 : 16),
            // Player info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.formattedDate} at ${entry.formattedTime}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Score
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: GameColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${entry.score}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank, bool isSmallScreen) {
    final size = isSmallScreen ? 40.0 : 50.0;

    if (rank <= 3) {
      final medals = ['🥇', '🥈', '🥉'];
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            medals[rank - 1],
            style: TextStyle(fontSize: isSmallScreen ? 28 : 36),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
