import 'package:flutter/material.dart';
import '../models/horse.dart';
import '../services/database_service.dart';

class HorsesScreen extends StatefulWidget {
  const HorsesScreen({super.key});

  @override
  State<HorsesScreen> createState() => _HorsesScreenState();
}

class _HorsesScreenState extends State<HorsesScreen> {
  List<Horse> horses = [];

  @override
  void initState() {
    super.initState();
    _loadHorses();
  }

  Future<void> _loadHorses() async {
    final loadedHorses = await DatabaseService.getHorses();
    setState(() {
      horses = loadedHorses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: horses.length,
          itemBuilder: (context, index) {
            final horse = horses[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: horse.isAvailable 
                          ? [const Color(0xFF4CAF50), const Color(0xFF8BC34A)]
                          : [Colors.grey, Colors.grey.shade400],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: Text(
                  horse.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${horse.breed} • ${horse.age} ans • ${horse.color}'),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getHealthColor(horse.healthStatus),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            horse.healthStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          horse.isAvailable ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: horse.isAvailable ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          horse.isAvailable ? 'Disponible' : 'Occupé',
                          style: TextStyle(
                            fontSize: 12,
                            color: horse.isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Modifier'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteHorse(index);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: FloatingActionButton(
          onPressed: _addHorse,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Color _getHealthColor(String status) {
    switch (status) {
      case 'Excellent':
        return Colors.green;
      case 'Bon':
        return Colors.blue;
      case 'Moyen':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  void _addHorse() {
    showDialog(
      context: context,
      builder: (context) => const AddHorseDialog(),
    ).then((horse) async {
      if (horse != null) {
        await DatabaseService.insertHorse(horse);
        _loadHorses();
      }
    });
  }

  void _deleteHorse(int index) async {
    await DatabaseService.deleteHorse(horses[index].id);
    _loadHorses();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cheval supprimé')),
      );
    }
  }
}

class AddHorseDialog extends StatefulWidget {
  const AddHorseDialog({super.key});

  @override
  State<AddHorseDialog> createState() => _AddHorseDialogState();
}

class _AddHorseDialogState extends State<AddHorseDialog> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _colorController = TextEditingController();
  String _gender = 'Étalon';
  String _healthStatus = 'Excellent';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un cheval'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: 'Race'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Âge'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Couleur'),
            ),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: 'Genre'),
              items: ['Étalon', 'Jument', 'Hongre']
                  .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (value) => setState(() => _gender = value!),
            ),
            DropdownButtonFormField<String>(
              value: _healthStatus,
              decoration: const InputDecoration(labelText: 'État de santé'),
              items: ['Excellent', 'Bon', 'Moyen', 'Mauvais']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) => setState(() => _healthStatus = value!),
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
          onPressed: _saveHorse,
          child: const Text('Ajouter'),
        ),
      ],
    );
  }

  void _saveHorse() {
    if (_nameController.text.isNotEmpty && _breedController.text.isNotEmpty) {
      final horse = Horse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        breed: _breedController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        color: _colorController.text,
        gender: _gender,
        healthStatus: _healthStatus,
      );
      Navigator.pop(context, horse);
    }
  }
}