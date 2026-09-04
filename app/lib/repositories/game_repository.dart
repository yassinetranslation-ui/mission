import '../services/game_service.dart';
import '../models/game_specification.dart';
import '../core/storage/local_cache.dart';

class GameRepository {
  final GameService _gameService;
  final LocalCache _localCache;

  GameRepository(this._gameService, this._localCache);

  Future<GameSpecification> getGame(String gameId, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _localCache.getCachedGame(gameId);
      if (cached != null) {
        return GameSpecification.fromJson(cached);
      }
    }

    try {
      final game = await _gameService.getGame(gameId);
      await _localCache.cacheGame(gameId, game.toJson());
      return game;
    } catch (e) {
      final cached = await _localCache.getCachedGame(gameId);
      if (cached != null) {
        return GameSpecification.fromJson(cached);
      }
      rethrow;
    }
  }

  Future<List<GameSpecification>> getGamesForChild(String childId) async {
    final games = await _gameService.getGamesForChild(childId);
    for (final game in games) {
      await _localCache.cacheGame(game.gameId, game.toJson());
    }
    return games;
  }

  Future<GameSpecification> generateGame(
    String lessonId, {
    String? childId,
    int durationMinutes = 10,
    String difficulty = 'medium',
  }) async {
    final game = await _gameService.generateGame(
      lessonId,
      childId: childId,
      durationMinutes: durationMinutes,
      difficulty: difficulty,
    );
    await _localCache.cacheGame(game.gameId, game.toJson());
    return game;
  }
}
