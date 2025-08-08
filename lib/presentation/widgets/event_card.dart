import 'package:flutter/material.dart';
import '../../data/models/diary_event_model.dart';

class EventCard extends StatelessWidget {
  final DiaryEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(event.description ?? ''),
      ),
    );
  }
}
