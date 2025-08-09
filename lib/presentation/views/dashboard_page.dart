import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../viewmodels/dashboard_vm.dart';
import '../widgets/event_card.dart';
import '../widgets/event_search_delegate.dart';
import '../../core/utils/time_formatter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static DateTime? lastPopTime;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<DashboardViewModel>(context, listen: false).loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final shouldPop = DashboardPage.lastPopTime == null ||
            now.difference(DashboardPage.lastPopTime!) > const Duration(seconds: 2);
        if (shouldPop) {
          DashboardPage.lastPopTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: ChangeNotifierProvider(
        create: (context) => DashboardViewModel(diaryRepository: context.read())..loadEvents(refresh: true),
        child: Consumer<DashboardViewModel>(
          builder: (context, vm, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Dashboard'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDateRange: vm.startDate != null && vm.endDate != null
                            ? DateTimeRange(start: vm.startDate!, end: vm.endDate!)
                            : null,
                      );
                      if (picked != null) {
                        vm.setDateRange(picked.start, picked.end);
                      } else {
                        vm.setDateRange(null, null); // Clear filter if cancelled
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: EventSearchDelegate(vm, vm.searchQuery),
                      );
                    },
                  ),
                ],
              ),
              body: _EventTimeline(
                scrollController: _scrollController,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.push('/new-event').then((_) {
                    // This callback is executed when the EventEntryPage is popped.
                    // We refresh the events to show the newly created event.
                    vm.loadEvents(refresh: true);
                  });
                },
                child: const Icon(Icons.add),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EventTimeline extends StatelessWidget {
  final ScrollController scrollController;

  const _EventTimeline({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    if (vm.isLoading && vm.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (vm.events.isEmpty && !vm.isLoading) {
      return const Center(child: Text('No events found. Add one!'));
    } else {
      return ListView.builder(
        controller: scrollController,
        itemCount: vm.events.length + (vm.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == vm.events.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final event = vm.events[index];
          return TimelineTile(
            alignment: TimelineAlign.start,
            isFirst: index == 0,
            isLast: index == vm.events.length - 1 && !vm.hasMore,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Colors.blue,
            ),
            endChild: EventCard(
              event: event,
              onEdit: () {
                context.push('/edit-event/${event.id}').then((_) {
                  vm.loadEvents(refresh: true);
                });
              },
              onDelete: () {
                vm.deleteEvent(event.id!);
              },
            ),
          );
        },
      );
    }
  }
}


