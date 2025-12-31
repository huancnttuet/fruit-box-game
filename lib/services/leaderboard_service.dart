import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/score_entry.dart';

/// Service for managing leaderboard data persistence
/// Uses Firebase Firestore for cloud storage with local storage fallback
class LeaderboardService {
  static const String _storageKey = 'fruit_box_leaderboard';
  static const String _firestoreCollection = 'leaderboard';
  static const int maxEntries = 10; // Keep top 10 scores

  /// Check if Firebase is initialized
  static bool get _isFirebaseAvailable {
    try {
      final available = Firebase.apps.isNotEmpty;
      debugPrint('Firebase available: $available');
      return available;
    } catch (e) {
      debugPrint('Firebase check error: $e');
      return false;
    }
  }

  /// Get Firestore instance
  static FirebaseFirestore? get _firestore {
    if (_isFirebaseAvailable) {
      try {
        return FirebaseFirestore.instance;
      } catch (e) {
        debugPrint('Firestore instance error: $e');
        return null;
      }
    }
    return null;
  }

  /// Save a new score entry to cloud and local storage
  static Future<void> saveScore(ScoreEntry entry) async {
    // Save to local storage first (always)
    await _saveToLocal(entry);

    // Try to save to Firestore with timeout
    final firestore = _firestore;
    if (firestore != null) {
      try {
        debugPrint('Saving to Firestore: ${entry.name} - ${entry.score}');
        final docRef = await firestore
            .collection(_firestoreCollection)
            .add({
              'name': entry.name,
              'score': entry.score,
              'dateTime': entry.dateTime.toIso8601String(),
              'timestamp': FieldValue.serverTimestamp(),
            })
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw Exception('Firestore save timeout');
              },
            );
        debugPrint('Firestore save success! Doc ID: ${docRef.id}');
      } catch (e) {
        // Firestore save failed, but we have local backup
        debugPrint('Firestore save failed: $e');
      }
    } else {
      debugPrint('Firestore not available for saving');
    }
  }

  /// Save to local storage
  static Future<void> _saveToLocal(ScoreEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await _getLocalScores();

    scores.add(entry);

    // Sort by score (highest first)
    scores.sort((a, b) => b.score.compareTo(a.score));

    // Keep only top entries
    final topScores = scores.take(maxEntries).toList();

    // Save to storage
    final jsonList = topScores.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Get scores from local storage
  static Future<List<ScoreEntry>> _getLocalScores() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ScoreEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all saved scores (prefers cloud, falls back to local)
  static Future<List<ScoreEntry>> getScores() async {
    // Try to get from Firestore first
    final firestore = _firestore;
    if (firestore != null) {
      try {
        debugPrint('Fetching scores from Firestore...');
        final snapshot = await firestore
            .collection(_firestoreCollection)
            .orderBy('score', descending: true)
            .limit(maxEntries)
            .get()
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw Exception('Firestore read timeout');
              },
            );

        debugPrint('Firestore returned ${snapshot.docs.length} documents');

        // Return Firestore results (even if empty, it means no scores yet in cloud)
        final scores = snapshot.docs.map((doc) {
          final data = doc.data();
          debugPrint('Doc: ${data['name']} - ${data['score']}');
          return ScoreEntry(
            name: data['name'] as String? ?? 'Unknown',
            score: (data['score'] as num?)?.toInt() ?? 0,
            dateTime: data['dateTime'] != null
                ? DateTime.parse(data['dateTime'] as String)
                : DateTime.now(),
          );
        }).toList();

        // If Firestore has data, return it; otherwise fall back to local
        if (scores.isNotEmpty) {
          return scores;
        }
        debugPrint('Firestore empty, checking local storage...');
      } catch (e) {
        debugPrint('Firestore read failed: $e');
      }
    } else {
      debugPrint('Firestore not available for reading');
    }

    // Fallback to local storage
    final localScores = await _getLocalScores();
    debugPrint('Returning ${localScores.length} local scores');
    return localScores;
  }

  /// Get the highest score
  static Future<int> getHighScore() async {
    final scores = await getScores();
    if (scores.isEmpty) return 0;
    return scores.first.score;
  }

  /// Check if a score qualifies for the leaderboard
  static Future<bool> isHighScore(int score) async {
    final scores = await getScores();
    if (scores.length < maxEntries) return true;
    return score > scores.last.score;
  }

  /// Clear all local scores (does not affect cloud)
  static Future<void> clearLocalScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /// Get the rank for a given score
  static Future<int> getRankForScore(int score) async {
    final scores = await getScores();
    int rank = 1;
    for (final entry in scores) {
      if (score > entry.score) break;
      rank++;
    }
    return rank;
  }

  /// Check if cloud storage is available
  static bool get isCloudAvailable =>
      _isFirebaseAvailable && _firestore != null;
}
