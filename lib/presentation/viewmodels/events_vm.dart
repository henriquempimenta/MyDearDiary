import 'package:flutter/material.dart';
import '../../data/models/diary_event_model.dart';
import '../../data/repositories/diary_repository.dart';

class EventsViewModel extends ChangeNotifier {
  final DiaryRepository diaryRepository;

  EventsViewModel({required this.diaryRepository});

  List<DiaryEvent> _events = [];
  List<DiaryEvent> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getAllEvents() async {
    _isLoading = true;
    notifyListeners();

    _events = await diaryRepository.getAllEvents();
    _isLoading = false;
    notifyListeners();
  }
}
