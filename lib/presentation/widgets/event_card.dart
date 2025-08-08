import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/diary_event_model.dart';
import '../../data/repositories/diary_repository.dart';
import '../../core/utils/time_formatter.dart';
import '../../presentation/viewmodels/dashboard_vm.dart';
import '../../presentation/viewmodels/events_vm.dart';

class EventCard extends StatelessWidget {
  final DiaryEvent event;

  const EventCard({super.key, required this.event});

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
                  context.push('/edit-event/${event.id}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () async {
                  Navigator.pop(bc);
                  final repository = Provider.of<DiaryRepository>(context, listen: false);
                  await repository.deleteEvent(event.id!); // Assuming id is not null for existing events
                  // Refresh the relevant ViewModel based on the current route
                  final currentRoute = GoRouterState.of(context).uri.toString();
                  if (currentRoute.startsWith('/dashboard')) {
                    Provider.of<DashboardViewModel>(context, listen: false).getEventsForDate(DateTime.now()); // Refresh current day
                  } else if (currentRoute.startsWith('/events')) {
                    Provider.of<EventsViewModel>(context, listen: false).getAllEvents();
                  }
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
