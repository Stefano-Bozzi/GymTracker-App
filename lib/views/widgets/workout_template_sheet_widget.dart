import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:robur_fit_x/data/notifiers.dart';
import 'package:robur_fit_x/data/workout_isar.dart';
import 'package:robur_fit_x/main.dart';

/// Opens the BottomSheet to create a workout template.
void workoutTemplateCreation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _CreateTemplateSheet(),
  );
}

/// Stateful widget for template creation. 
/// Uses a separate State class to preserve user input during UI rebuilds.
class _CreateTemplateSheet extends StatefulWidget {
  const _CreateTemplateSheet();

  // Instantiates and links the mutable state to this widget.
  @override
  State<_CreateTemplateSheet> createState() => _CreateTemplateSheetState();
}

/// State for [`_CreateTemplateSheet`] that preserves user input across rebuilds.
/// Holds the template name controller and a list of exercises
/// (each with its own controller and set count).
class _CreateTemplateSheetState extends State<_CreateTemplateSheet> {
  final TextEditingController _templateWorkoutName = TextEditingController();
  // temporary list to manage space before saving
  final List<Map<String, dynamic>> _exercises = [];

  // function to add a new exercise
  void _addExercise() {
    setState(() {
      _exercises.add({
        'nameController': TextEditingController(),
        'sets': 1,
      });
    });
  }

  // Creates domain objects and saves to Isar
  // ...

  // Delate unnecessary information when exit
  @override
  void dispose() {
    _templateWorkoutName.dispose();
    for (var exc in _exercises) {
      exc['nameController'].dispose();
    }
    super.dispose();
  }

  // Graphics and UI
@override
  Widget build(BuildContext context) {
  // make always visible the box, rising it when keyboard is present
  final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
  
  return Padding(
    padding: EdgeInsets.only(bottom: bottomPadding, left: 16, right: 16, top: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Create New Workout Template', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 36),   
    
        // Template Workout Name
        TextField(
          controller: _templateWorkoutName,
          decoration: InputDecoration(labelText: 'Workout Name', border: OutlineInputBorder()),
        ),

        const SizedBox(height: 36),
        // create a flexible list to manage exercises definitions
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _exercises.length,
            itemBuilder: (context, index){
            final exc = _exercises[index];
              return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: exc['nameController'],
                            decoration: InputDecoration(labelText: 'Exercise ${index + 1}'),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                );
            }// create the item
          ),
        ),
        
        const SizedBox(height: 36),

        // Buttons to add exercises and save template
        Row( // so buttons are on a single row

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
            child: FilledButton.icon(
                onPressed: _addExercise,
                icon: const Icon(Icons.add),
                label: const Text('Add Exercise'),
                ),
            ),
            const SizedBox(width: 16),
            Expanded(
            child: FilledButton.icon(
              onPressed: (){}, // here the saving
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              ),
            )
          ],
        ),
        
        const SizedBox(height: 36), // Margine inferiore
      ],
    ),
  );
  }
}