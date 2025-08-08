import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/diary_event_model.dart';
import '../viewmodels/event_form_vm.dart';

class EventEntryPage extends StatelessWidget {
  final DiaryEvent? event;

  const EventEntryPage({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventFormViewModel(diaryRepository: context.read(), initialEvent: event),
      child: Consumer<EventFormViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(event == null ? 'New Event' : 'Edit Event'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    if (await vm.saveEvent()) {
                      context.go('/dashboard');
                    }
                  },
                ),
              ],
            ),
            body: Form(
              key: vm.formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: vm.titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await vm.getUniqueTitles(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        vm.titleController.text = suggestion;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: vm.descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: vm.startTime.toLocal().toString().split('.')[0]),
                      decoration: const InputDecoration(labelText: 'Start Time'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: vm.startTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(vm.startTime),
                          );
                          if (time != null) {
                            vm.setStartTime(DateTime(date.year, date.month, date.day, time.hour, time.minute));
                          }
                        }
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: vm.endTime?.toLocal().toString().split('.')[0] ?? ''),
                      decoration: const InputDecoration(labelText: 'End Time (Optional)'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: vm.endTime ?? vm.startTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(vm.endTime ?? vm.startTime),
                          );
                          if (time != null) {
                            vm.setEndTime(DateTime(date.year, date.month, date.day, time.hour, time.minute));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
