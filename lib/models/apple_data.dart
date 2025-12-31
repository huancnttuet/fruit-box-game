/// Model class representing an apple's data
class AppleData {
  final int value;
  final int row;
  final int col;
  bool isCollected;

  AppleData({
    required this.value,
    required this.row,
    required this.col,
    this.isCollected = false,
  });
}
