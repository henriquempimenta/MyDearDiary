import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../viewmodels/dashboard_vm.dart';
import '../widgets/event_card.dart';
import '../../core/utils/time_formatter.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(diaryRepository: context.read())..getEventsForDate(DateTime.now()),
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDateRange: vm.selectedDateRange,
                    );
                    if (picked != null) {
                      vm.getEventsForDateRange(picked);
                    }
                  },
                ),
              ],
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.events.isEmpty
                    ? const Center(child: Text('No events for today. Add one!'))
                    : ListView.builder(
                        itemCount: vm.events.length,
                        itemBuilder: (context, index) {
                          final event = vm.events[index];
                          return TimelineTile(
                            alignment: TimelineAlign.center,
                            isFirst: index == 0,
                            isLast: index == vm.events.length - 1,
                            indicatorStyle: const IndicatorStyle(
                              width: 20,
                              color: Colors.blue,
                            ),
                            startChild: Text(formatRelativeTime(event.startTime)),
                            endChild: EventCard(event: event),
                          );
                        },
                      ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.go('/new-event'),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
