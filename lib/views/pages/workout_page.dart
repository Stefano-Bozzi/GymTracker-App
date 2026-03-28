//________________________________________________________________
// WORKOUTS: page that contains all type of saved workouts
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:gym_tracker/main.dart';
import 'package:gym_tracker/data/notifiers.dart';
import 'package:gym_tracker/data/workout_isar.dart';
import 'package:gym_tracker/views/widgets/workout_template_sheet_widget.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState(); 
}

class _WorkoutPageState extends State<WorkoutPage>{

  List<IsarTemplateWorkout> _templates = [];

  @override
  void initState() {
    super.initState();
    
    _loadTemplates();

    // refresh page if notifier change
    refreshWorkoutPageNotifier.addListener(_loadTemplates);
  }

  /// Find all Templates and load in reversed-chronological order
  Future<void> _loadTemplates() async {
    // find all
    final templatesFromDB = await isar.isarTemplateWorkouts.where().findAll();

    setState(() {
      // reverse the order
      _templates = templatesFromDB.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
      ),
      // if empty list show message
      body: _templates.isEmpty
          ? const Center(child: Text("No workouts yet. Tap the + button to create one!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                
                // Graphic and Actions
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(template.name)
                        ),
                        const SizedBox(width: 16),
                        // Sets counter
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 185, 35, 35),),
                              onPressed: () => deleteIsarElement(isar, isar.isarTemplateWorkouts, template.id, refreshWorkoutPageNotifier, context)
                            ),
                              const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => 
                              workoutTemplateCreation(context,templateToEdit: template)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}