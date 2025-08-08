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

  DateTimeRange _selectedDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTimeRange get selectedDateRange => _selectedDateRange;

  void getEventsForDate(DateTime date) async {
    getEventsForDateRange(DateTimeRange(start: date, end: date));
  }

  void getEventsForDateRange(DateTimeRange dateRange) async {
    _selectedDateRange = dateRange;
    _isLoading = true;
    notifyListeners();

    final start = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
    final end = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day).add(const Duration(days: 1));

    _events = await diaryRepository.getEventsForDateRange(start, end);
    _isLoading = false;
    notifyListeners();
  }
}
