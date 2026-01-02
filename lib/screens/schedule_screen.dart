import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  
  final Map<DateTime, List<ScheduleItem>> _schedule = {
    DateTime.now(): [
      ScheduleItem(
        time: '09:00',
        title: 'Cours débutant',
        instructor: 'Marie L.',
        location: 'Manège 1',
      ),
      ScheduleItem(
        time: '14:00',
        title: 'Dressage avancé',
        instructor: 'Pierre M.',
        location: 'Carrière',
      ),
    ],
    DateTime.now().add(const Duration(days: 1)): [
      ScheduleItem(
        time: '10:00',
        title: 'Saut d\'obstacles',
        instructor: 'Sophie D.',
        location: 'Manège 2',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCalendarHeader(),
          _buildWeekView(),
          Expanded(child: _buildScheduleList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addScheduleItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 7));
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            DateFormat('MMMM yyyy', 'fr_FR').format(_selectedDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 7));
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDate = date),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.brown : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E', 'fr_FR').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleList() {
    final dayKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final items = _schedule[dayKey] ?? [];
    
    if (items.isEmpty) {
      return const Center(
        child: Text('Aucun cours prévu pour cette date'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  item.time,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            title: Text(item.title),
            subtitle: Text('${item.instructor} • ${item.location}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Modifier'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Supprimer'),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  setState(() {
                    items.removeAt(index);
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _addScheduleItem() {
    showDialog(
      context: context,
      builder: (context) => AddScheduleDialog(selectedDate: _selectedDate),
    ).then((item) {
      if (item != null) {
        final dayKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
        setState(() {
          _schedule[dayKey] = (_schedule[dayKey] ?? [])..add(item);
        });
      }
    });
  }
}

class ScheduleItem {
  final String time;
  final String title;
  final String instructor;
  final String location;

  ScheduleItem({
    required this.time,
    required this.title,
    required this.instructor,
    required this.location,
  });
}

class AddScheduleDialog extends StatefulWidget {
  final DateTime selectedDate;
  
  const AddScheduleDialog({super.key, required this.selectedDate});

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final _titleController = TextEditingController();
  final _instructorController = TextEditingController();
  final _locationController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouveau cours - ${DateFormat('dd/MM/yyyy').format(widget.selectedDate)}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Titre du cours'),
          ),
          TextField(
            controller: _instructorController,
            decoration: const InputDecoration(labelText: 'Instructeur'),
          ),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Lieu'),
          ),
          ListTile(
            title: const Text('Heure'),
            subtitle: Text(_selectedTime.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: _selectTime,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveScheduleItem,
          child: const Text('Ajouter'),
        ),
      ],
    );
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _saveScheduleItem() {
    if (_titleController.text.isNotEmpty) {
      final item = ScheduleItem(
        time: _selectedTime.format(context),
        title: _titleController.text,
        instructor: _instructorController.text,
        location: _locationController.text,
      );
      Navigator.pop(context, item);
    }
  }
}