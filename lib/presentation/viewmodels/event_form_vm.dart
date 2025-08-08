import 'dart:async';

import 'package:flutter/material.dart';
import '../../data/models/diary_event_model.dart';
import '../../data/repositories/diary_repository.dart';

class EventFormViewModel extends ChangeNotifier {
  final DiaryRepository diaryRepository;
  final DiaryEvent? initialEvent;

  Timer? _debounce;

  EventFormViewModel({required this.diaryRepository, this.initialEvent}) {
    if (initialEvent != null) {
      titleController.text = initialEvent!.title;
      descriptionController.text = initialEvent!.description ?? '';
      _startTime = initialEvent!.startTime;
      _endTime = initialEvent!.endTime;
    }
  }

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime _startTime = DateTime.now();
  DateTime get startTime => _startTime;

  DateTime? _endTime;
  DateTime? get endTime => _endTime;

  Future<bool> saveEvent() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final event = DiaryEvent(
        id: initialEvent?.id,
        title: titleController.text,
        description: descriptionController.text,
        startTime: _startTime,
        endTime: _endTime,
      );

      if (initialEvent == null) {
        await diaryRepository.addEvent(event);
      } else {
        await diaryRepository.updateEvent(event);
      }
      return true;
    }
    return false;
  }

  void setStartTime(DateTime time) {
    _startTime = time;
    notifyListeners();
  }

  void setEndTime(DateTime? time) {
    _endTime = time;
    notifyListeners();
  }

  Future<List<String>> getUniqueTitles(String pattern) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final completer = Completer<List<String>>();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final titles = await diaryRepository.getUniqueTitles(pattern);
      completer.complete(titles);
    });
    return completer.future;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
