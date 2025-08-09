import 'package:flutter/material.dart';
import '../../data/models/diary_event_model.dart';
import '../../data/repositories/diary_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DiaryRepository diaryRepository;

  DashboardViewModel({required this.diaryRepository});

  final List<DiaryEvent> _events = [];
  List<DiaryEvent> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  int _offset = 0;
  final int _limit = 50;

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadEvents(refresh: true);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    loadEvents(refresh: true);
  }

  Future<void> deleteEvent(int eventId) async {
    await diaryRepository.deleteEvent(eventId);
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
      startDate: _startDate,
      endDate: _endDate,
    );

    _events.addAll(newEvents);
    _offset += newEvents.length;
    _hasMore = newEvents.length == _limit;

    _isLoading = false;
    Future.microtask(() => notifyListeners());
  }
}
