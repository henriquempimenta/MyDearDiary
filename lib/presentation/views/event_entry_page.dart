import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_form_vm.dart';

class EventEntryPage extends StatelessWidget {
  const EventEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventFormViewModel(diaryRepository: context.read()),
      child: Consumer<EventFormViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('New Event'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    if (await vm.saveEvent()) {
                      Navigator.of(context).pop();
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
