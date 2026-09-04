import '../services/child_service.dart';
import '../models/child_profile.dart';

class ChildRepository {
  final ChildService _childService;
  
  List<ChildProfile>? _cachedChildren;

  ChildRepository(this._childService);

  Future<List<ChildProfile>> getChildren({bool forceRefresh = false}) async {
    if (_cachedChildren != null && !forceRefresh) {
      return _cachedChildren!;
    }
    
    _cachedChildren = await _childService.getChildren();
    return _cachedChildren!;
  }

  Future<ChildProfile> getChild(String id) async {
    final child = await _childService.getChild(id);
    _updateCache(child);
    return child;
  }

  Future<ChildProfile> createChild(CreateChildRequest request) async {
    final child = await _childService.createChild(request);
    _cachedChildren?.add(child);
    return child;
  }

  Future<ChildProfile> updateChild(String id, UpdateChildRequest request) async {
    final child = await _childService.updateChild(id, request);
    _updateCache(child);
    return child;
  }

  Future<void> deleteChild(String id) async {
    await _childService.deleteChild(id);
    _cachedChildren?.removeWhere((c) => c.id == id);
  }

  void _updateCache(ChildProfile child) {
    if (_cachedChildren == null) return;
    final index = _cachedChildren!.indexWhere((c) => c.id == child.id);
    if (index != -1) {
      _cachedChildren![index] = child;
    } else {
      _cachedChildren!.add(child);
    }
  }
}
