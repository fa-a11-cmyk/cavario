import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../services/database_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final loadedEvents = await DatabaseService.getEvents();
    setState(() {
      events = loadedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(event.type),
                        backgroundColor: _getTypeColor(event.type),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(event.description),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(event.dateTime)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(event.location),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16),
                      const SizedBox(width: 4),
                      Text('${event.participants.length}/${event.maxParticipants} participants'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _deleteEvent(index),
                        child: const Text('Supprimer'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: event.participants.length < event.maxParticipants
                            ? () => _joinEvent(index)
                            : null,
                        child: const Text('Rejoindre'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Cours':
        return Colors.blue.shade100;
      case 'Compétition':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => const AddEventDialog(),
    ).then((event) {
      if (event != null) {
        setState(() {
          events.add(event);
        });
      }
    });
  }

  void _joinEvent(int index) {
    setState(() {
      events[index].participants.add('current_user');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inscription confirmée')),
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Événement supprimé')),
    );
  }
}

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _eventType = 'Cours';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Créer un événement'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lieu'),
            ),
            TextField(
              controller: _maxParticipantsController,
              decoration: const InputDecoration(labelText: 'Participants max'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _eventType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: ['Cours', 'Compétition', 'Stage', 'Sortie']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => _eventType = value!),
            ),
            ListTile(
              title: const Text('Date et heure'),
              subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveEvent,
          child: const Text('Créer'),
        ),
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  void _saveEvent() {
    if (_titleController.text.isNotEmpty) {
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: _selectedDate,
        location: _locationController.text,
        maxParticipants: int.tryParse(_maxParticipantsController.text) ?? 10,
        type: _eventType,
      );
      Navigator.pop(context, event);
    }
  }
}