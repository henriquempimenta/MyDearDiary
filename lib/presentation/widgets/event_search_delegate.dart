import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dashboard_vm.dart';
import '../widgets/event_card.dart';

class EventSearchDelegate extends SearchDelegate {
  final DashboardViewModel viewModel;

  EventSearchDelegate(this.viewModel, String initialQuery) {
    query = initialQuery;
  }

  @override
  set query(String value) {
    super.query = value;
    viewModel.setSearchQuery(value);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          viewModel.setSearchQuery('');
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        viewModel.setSearchQuery(query); // Save current query when closing
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    viewModel.setSearchQuery(query);
    return Consumer<DashboardViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading && vm.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.events.isEmpty) {
          return const Center(child: Text('No results found.'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Found ${vm.events.length} events'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vm.events.length,
                itemBuilder: (context, index) {
                  final event = vm.events[index];
                  return EventCard(
                    event: event,
                    onEdit: () {
                      context.push('/edit-event/${event.id}').then((_) {
                        vm.loadEvents(refresh: true);
                      });
                    },
                    onDelete: () {
                      vm.deleteEvent(event.id!);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    viewModel.setSearchQuery(query);
    return Consumer<DashboardViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading && vm.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.events.isEmpty) {
          return const Center(child: Text('No suggestions.'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Found ${vm.events.length} events'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vm.events.length,
                itemBuilder: (context, index) {
                  final event = vm.events[index];
                  return EventCard(
                    event: event,
                    onEdit: () {
                      context.push('/edit-event/${event.id}').then((_) {
                        vm.loadEvents(refresh: true);
                      });
                    },
                    onDelete: () {
                      vm.deleteEvent(event.id!);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
