import 'package:flutter/material.dart';
import '../../data/models/diary_event_model.dart';
import '../../core/utils/time_formatter.dart';

class EventCard extends StatelessWidget {
  final DiaryEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventCard({super.key, required this.event, required this.onEdit, required this.onDelete});

  void _showEventOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(bc);
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(bc);
                  onDelete();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share (TODO)'),
                onTap: () {
                  Navigator.pop(bc);
                  // TODO: Implement share functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () => _showEventOptions(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${formatRelativeTime(event.startTime)} - ${event.description ?? ''}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
