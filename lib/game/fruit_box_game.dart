import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/apple_component.dart';
import '../components/selection_rect_component.dart';
import '../constants/game_constants.dart';

/// Main Flame game class for Fruit Box
class FruitBoxGame extends FlameGame with PanDetector {
  final VoidCallback onScoreUpdate;
  final VoidCallback onGameOver;

  int score = 0;
  int timeLeft = GameConstants.gameDuration;
  bool isGameOver = false;
  bool isGameStarted = false;

  late List<List<AppleComponent>> apples;
  Vector2? dragStart;
  Vector2? dragEnd;
  SelectionRectComponent? selectionRect;

  double cellWidth = 0;
  double cellHeight = 0;

  FruitBoxGame({required this.onScoreUpdate, required this.onGameOver});

  @override
  Color backgroundColor() => GameColors.gameBackground;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initializeGrid();
  }

  /// Initialize the apple grid with random values
  void _initializeGrid() {
    final random = Random();
    apples = [];

    cellWidth = size.x / GameConstants.gridCols;
    cellHeight = size.y / GameConstants.gridRows;

    for (int row = 0; row < GameConstants.gridRows; row++) {
      List<AppleComponent> rowApples = [];
      for (int col = 0; col < GameConstants.gridCols; col++) {
        final value =
            random.nextInt(GameConstants.maxAppleValue) +
            GameConstants.minAppleValue;
        final apple = AppleComponent(
          value: value,
          row: row,
          col: col,
          cellSize: Vector2(cellWidth, cellHeight),
        );
        apple.position = Vector2(col * cellWidth, row * cellHeight);
        add(apple);
        rowApples.add(apple);
      }
      apples.add(rowApples);
    }
  }

  /// Start a new game
  void startGame() {
    isGameStarted = true;
    isGameOver = false;
    score = 0;
    timeLeft = GameConstants.gameDuration;
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!isGameStarted || isGameOver) return;
      timeLeft--;
      onScoreUpdate();
      if (timeLeft <= 0) {
        isGameOver = true;
        onGameOver();
      } else {
        _startTimer();
      }
    });
  }

  // ============== PAN GESTURE HANDLERS ==============

  @override
  void onPanStart(DragStartInfo info) {
    if (isGameOver || !isGameStarted) return;
    final pos = info.raw.localPosition;
    dragStart = Vector2(pos.dx, pos.dy);
    dragEnd = Vector2(pos.dx, pos.dy);
    _updateSelection();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (isGameOver || !isGameStarted) return;
    final pos = info.raw.localPosition;
    dragEnd = Vector2(pos.dx, pos.dy);
    _updateSelection();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (isGameOver || !isGameStarted) return;

    final selectedApples = _getSelectedApples();
    final sum = _calculateSum(selectedApples);

    if (sum == GameConstants.targetSum && selectedApples.isNotEmpty) {
      _collectApples(selectedApples);
    }

    _clearSelection();
  }

  // ============== SELECTION LOGIC ==============

  void _updateSelection() {
    if (dragStart == null || dragEnd == null) return;

    selectionRect?.removeFromParent();

    final left = min(dragStart!.x, dragEnd!.x);
    final top = min(dragStart!.y, dragEnd!.y);
    final width = (dragStart!.x - dragEnd!.x).abs();
    final height = (dragStart!.y - dragEnd!.y).abs();

    final selectedApples = _getSelectedApples();
    final sum = _calculateSum(selectedApples);
    final isValid = sum == GameConstants.targetSum;

    selectionRect = SelectionRectComponent(
      position: Vector2(left, top),
      size: Vector2(width, height),
      isValid: isValid,
      sum: sum,
    );
    add(selectionRect!);

    _highlightSelectedApples(selectedApples, isValid);
  }

  void _highlightSelectedApples(
    List<AppleComponent> selectedApples,
    bool isValid,
  ) {
    for (final row in apples) {
      for (final apple in row) {
        apple.isSelected = selectedApples.contains(apple);
        apple.isValidSelection = isValid;
      }
    }
  }

  void _clearSelection() {
    dragStart = null;
    dragEnd = null;
    selectionRect?.removeFromParent();
    selectionRect = null;
    for (final row in apples) {
      for (final apple in row) {
        apple.isSelected = false;
      }
    }
  }

  List<AppleComponent> _getSelectedApples() {
    if (dragStart == null || dragEnd == null) return [];

    final left = min(dragStart!.x, dragEnd!.x);
    final right = max(dragStart!.x, dragEnd!.x);
    final top = min(dragStart!.y, dragEnd!.y);
    final bottom = max(dragStart!.y, dragEnd!.y);

    List<AppleComponent> selected = [];
    for (final row in apples) {
      for (final apple in row) {
        if (apple.isCollected) continue;
        final center = apple.center;
        if (center.x + apple.size.x / 2 >= left &&
            center.x - apple.size.x / 2 <= right &&
            center.y + apple.size.y / 2 >= top &&
            center.y - apple.size.y / 2 <= bottom) {
          selected.add(apple);
        }
      }
    }
    return selected;
  }

  int _calculateSum(List<AppleComponent> apples) {
    return apples.fold<int>(0, (sum, apple) => sum + apple.value);
  }

  void _collectApples(List<AppleComponent> selectedApples) {
    for (final apple in selectedApples) {
      apple.collect();
    }
    score += selectedApples.length;
    onScoreUpdate();
  }
}
