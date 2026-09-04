import '../services/progress_service.dart';
import '../models/learning_progress.dart';
import '../models/learning_report.dart';

class ProgressRepository {
  final ProgressService _progressService;
  
  ChildProgress? _cachedProgress;

  ProgressRepository(this._progressService);

  Future<ChildProgress> getChildProgress(String childId, {bool forceRefresh = false}) async {
    if (_cachedProgress != null && !forceRefresh && _cachedProgress!.childId == childId) {
      return _cachedProgress!;
    }
    
    _cachedProgress = await _progressService.getChildProgress(childId);
    return _cachedProgress!;
  }

  Future<LearningReport> getLearningReport(String childId, {String? lessonId}) async {
    return _progressService.getLearningReport(childId, lessonId: lessonId);
  }
  
  void clearCache() {
    _cachedProgress = null;
  }
}
