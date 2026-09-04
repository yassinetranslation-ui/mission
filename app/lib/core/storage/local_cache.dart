import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

class LocalCache {
  static const String _gamesBoxName = 'cached_games';
  late Box<String> _gamesBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _gamesBox = await Hive.openBox<String>(_gamesBoxName);
  }

  Future<void> cacheGame(String gameId, Map<String, dynamic> gameData) async {
    await _gamesBox.put(gameId, jsonEncode(gameData));
  }

  Future<Map<String, dynamic>?> getCachedGame(String gameId) async {
    final data = _gamesBox.get(gameId);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }
  
  Future<List<Map<String, dynamic>>> getCachedGames() async {
    return _gamesBox.values.map((data) => jsonDecode(data) as Map<String, dynamic>).toList();
  }

  bool isCached(String gameId) {
    return _gamesBox.containsKey(gameId);
  }

  Future<void> clearCache() async {
    await _gamesBox.clear();
  }
}
