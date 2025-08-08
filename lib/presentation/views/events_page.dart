import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/events_vm.dart';
import '../widgets/event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventsViewModel(diaryRepository: context.read())..getAllEvents(),
      child: Consumer<EventsViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Events'),
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: vm.events.length,
                    itemBuilder: (context, index, animation) {
                      final event = vm.events[index];
                      return FadeTransition(
                        opacity: animation,
                        child: EventCard(event: event),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
