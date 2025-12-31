import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';
import '../game/fruit_box_game.dart';
import '../widgets/game_header.dart';
import '../widgets/game_instructions.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/start_screen.dart';

/// Main game screen widget
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FruitBoxGame game;
  bool isGameStarted = false;

  @override
  void initState() {
    super.initState();
    _createNewGame();
  }

  void _createNewGame() {
    game = FruitBoxGame(onScoreUpdate: _onScoreUpdate, onGameOver: _onGameOver);
  }

  void _onScoreUpdate() {
    setState(() {});
  }

  void _onGameOver() {
    setState(() {});
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
      return StartScreen(onStart: _startGame, isSmallScreen: isSmallScreen);
    }

    return Stack(
      children: [
        GameWidget(game: game),
        if (game.isGameOver)
          GameOverOverlay(
            score: game.score,
            onPlayAgain: _playAgain,
            isSmallScreen: isSmallScreen,
          ),
      ],
    );
  }
}
