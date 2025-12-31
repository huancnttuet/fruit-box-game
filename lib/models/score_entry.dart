/// Model class representing a player's score entry
class ScoreEntry {
  final String name;
  final int score;
  final DateTime dateTime;

  ScoreEntry({required this.name, required this.score, required this.dateTime});

  /// Convert to JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      name: json['name'] as String,
      score: json['score'] as int,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  /// Format the date for display
  String get formattedDate {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  /// Format the time for display
  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
