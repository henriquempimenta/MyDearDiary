import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../viewmodels/dashboard_vm.dart';
import '../widgets/event_card.dart';
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
              body: Builder(
                builder: (context) {
                  if (vm.isLoading && vm.events.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (vm.events.isEmpty && !vm.isLoading) {
                    return const Center(child: Text('No events found. Add one!'));
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
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
                          endChild: EventCard(event: event),
                        );
                      },
                    );
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => context.push('/new-event'),
                child: const Icon(Icons.add),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EventSearchDelegate extends SearchDelegate {
  final DashboardViewModel viewModel;

  EventSearchDelegate(this.viewModel, String initialQuery) {
    query = initialQuery;
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
                  return EventCard(event: event);
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
                  return EventCard(event: event);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
