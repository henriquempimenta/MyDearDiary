import 'package:flutter/material.dart';
import '../../data/models/diary_event_model.dart';
import '../../data/repositories/diary_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DiaryRepository diaryRepository;

  DashboardViewModel({required this.diaryRepository});

  List<DiaryEvent> _events = [];
  List<DiaryEvent> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _offset = 0;
  final int _limit = 50;

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadEvents(refresh: true);
  }

  Future<void> loadEvents({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _events.clear();
      _offset = 0;
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    Future.microtask(() => notifyListeners());

    final newEvents = await diaryRepository.getEventsPaginated(
      limit: _limit,
      offset: _offset,
      query: _searchQuery,
    );

    _events.addAll(newEvents);
    _offset += newEvents.length;
    _hasMore = newEvents.length == _limit;

    _isLoading = false;
    Future.microtask(() => notifyListeners());
  }
}
