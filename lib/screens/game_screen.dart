import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';
import '../game/fruit_box_game.dart';
import '../models/score_entry.dart';
import '../services/leaderboard_service.dart';
import '../widgets/game_header.dart';
import '../widgets/game_instructions.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/name_input_dialog.dart';
import '../widgets/start_screen.dart';
import 'leaderboard_screen.dart';

/// Main game screen widget
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FruitBoxGame game;
  bool isGameStarted = false;
  bool _hasShownNameDialog = false;

  @override
  void initState() {
    super.initState();
    _createNewGame();
  }

  void _createNewGame() {
    game = FruitBoxGame(onScoreUpdate: _onScoreUpdate, onGameOver: _onGameOver);
    _hasShownNameDialog = false;
  }

  void _onScoreUpdate() {
    setState(() {});
  }

  void _onGameOver() {
    setState(() {});
    // Show name input dialog after game over
    if (!_hasShownNameDialog) {
      _hasShownNameDialog = true;
      _showNameInputDialog();
    }
  }

  Future<void> _showNameInputDialog() async {
    // Wait a short moment for UI to update
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    final name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => NameInputDialog(score: game.score),
    );

    if (name != null && name.isNotEmpty) {
      final entry = ScoreEntry(
        name: name,
        score: game.score,
        dateTime: DateTime.now(),
      );
      await LeaderboardService.saveScore(entry);
    }
  }

  void _startGame() {
    setState(() {
      isGameStarted = true;
      game.startGame();
    });
  }

  void _resetGame() {
    setState(() {
      isGameStarted = false;
      _createNewGame();
    });
  }

  void _playAgain() {
    _resetGame();
    _startGame();
  }

  void _openLeaderboard() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LeaderboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: GameColors.background,
      body: SafeArea(
        child: Column(
          children: [
            GameHeader(
              score: game.score,
              timeLeft: game.timeLeft,
              onReset: _resetGame,
              onLeaderboard: _openLeaderboard,
              isSmallScreen: isSmallScreen,
            ),
            GameInstructions(isSmallScreen: isSmallScreen),
            Expanded(child: _buildGameArea(isSmallScreen)),
          ],
        ),
      ),
    );
  }

  Widget _buildGameArea(bool isSmallScreen) {
    if (!isGameStarted) {
      return StartScreen(
        onStart: _startGame,
        onLeaderboard: _openLeaderboard,
        isSmallScreen: isSmallScreen,
      );
    }

    return Stack(
      children: [
        GameWidget(game: game),
        if (game.isGameOver)
          GameOverOverlay(
            score: game.score,
            onPlayAgain: _playAgain,
            onLeaderboard: _openLeaderboard,
            isSmallScreen: isSmallScreen,
          ),
      ],
    );
  }
}
