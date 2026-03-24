import 'package:flutter/material.dart';
import 'package:robur_fit_x/data/notifiers.dart';
import 'package:robur_fit_x/data/workout_isar.dart';
import 'package:robur_fit_x/data/workout.dart';
import 'package:robur_fit_x/main.dart';
import 'package:isar/isar.dart';

/// Show a list of all templates to start a new session
void showAllTemplates(BuildContext context) async {
  final templates = await isar.isarTemplateWorkouts.where().findAll();
  
  if (!context.mounted) return;

  // list in a BottomSheet
  showModalBottomSheet(
    context: context,
    builder: (context) {
      if (templates.isEmpty) {
         return const Padding(
           padding: EdgeInsets.all(32.0),
           child: Center(child: Text("No templates found. Go to Workouts to create one!")),
         );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: templates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(templates[index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${templates[index].exercises.length} Exercises'),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              // close selector
              Navigator.pop(context);
              // open session creation
              workoutSessionCreation(context, baseTemplate: templates[index]);
            },
          );
        },
      );
    }
  );
}

/// Opens the BottomSheet to create a workout session.
void workoutSessionCreation(BuildContext context, {IsarWorkout? sessionToEdit, IsarTemplateWorkout? baseTemplate}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _CreateSessionSheet(sessionToEdit: sessionToEdit, baseTemplate: baseTemplate),
  );
}

/// Stateful widget for session creation. 
class _CreateSessionSheet extends StatefulWidget {
  final IsarWorkout? sessionToEdit;
  final IsarTemplateWorkout? baseTemplate;

  const _CreateSessionSheet({super.key, this.sessionToEdit, this.baseTemplate});

  @override
  State<_CreateSessionSheet> createState() => _CreateSessionSheetState();
}

/// State for [`_CreateSessionSheet`] 
class _CreateSessionSheetState extends State<_CreateSessionSheet> {
  final TextEditingController _sessionWorkoutName = TextEditingController();
  final List<Map<String, dynamic>> _exercises = [];

  @override
  void initState() {
    super.initState();
    
    // A. if modify an existing session
    if (widget.sessionToEdit != null) {
      _sessionWorkoutName.text = widget.sessionToEdit!.name;
      for (var exc in widget.sessionToEdit!.exercises) {
        _exercises.add({
          'nameController': TextEditingController(text: exc.name),
          'sets': exc.sets.length,
          'focusNode': FocusNode(),
        });
      }
    } 
    // B. if creating new one
    else if (widget.baseTemplate != null) {
      _sessionWorkoutName.text = widget.baseTemplate!.name;
      for (var exc in widget.baseTemplate!.exercises) {
        _exercises.add({
          'nameController': TextEditingController(text: exc.name),
          'sets': exc.sets.length,
          'focusNode': FocusNode(),
        });
      }
    }
  }

  /// function to add a new exercise
  void _addExercise() {
    final newFocus = FocusNode(); 
    setState(() {
      _exercises.add({
        'nameController': TextEditingController(),
        'sets': 1,
        'focusNode': newFocus,
      });
    });
    newFocus.requestFocus(); 
  }

  /// Show an error message
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Attention", style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Create SessionWorkout from a current sheet state
  Workout createSessionWorkout() {
    String sessionName = _sessionWorkoutName.text.trim();
    List<Exercise> exercises = [];
    
    for (var exc in _exercises) {
      // Default values (0 or current date)
      List<WorkoutSet> sessionSet = List.generate(exc['sets'], (index) => WorkoutSet(reps: 0, weight: 0.0));
      exercises.add(Exercise(name: exc['nameController'].text.trim(), groupMuscle: "", sets: sessionSet));
    }
    
    if (widget.sessionToEdit != null) {
      return Workout(
        id: widget.sessionToEdit!.id, 
        name: sessionName, 
        date: widget.sessionToEdit!.date,
        totVolume: widget.sessionToEdit!.totVolume,
        exercises: exercises
      );
    } else {
      return Workout(
        name: sessionName, 
        date: DateTime.now(), // current date
        totVolume: 0.0,
        exercises: exercises
      );
    }
  }

  /// Save a Session workout in smartphone storage
  Future<void> _saveSession() async{
    if (_sessionWorkoutName.text.trim().isEmpty) {
      _showError("Workout Session MUST have a name");
      return;
    }
    if (_exercises.isEmpty) {
      _showError("You MUST add at least one exercise");
      return;
    }
    for (var exercise in _exercises) {
      if (exercise['nameController'].text.trim().isEmpty) {
        _showError("All Exercises MUST have a name");
        return;  
      }
    }
    
    // here the saving
    Workout finalWorkout = createSessionWorkout();
    await isar.writeTxn(() async {
      await isar.isarWorkouts.put(finalWorkout.toIsar());
    });

    refreshCalendarPageNotifier.value = !refreshCalendarPageNotifier.value;
    
    if (!mounted) return;
    
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout Session Successfully Saved")),
    );
  }

  @override
  void dispose() {
    _sessionWorkoutName.dispose();
    for (var exc in _exercises) {
      exc['nameController'].dispose();
      exc['focusNode'].dispose();
    }
    super.dispose();
  }

  // Graphics and UI
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, left: 16, right: 16, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Create New Workout Session', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 36),   
      
          TextField(
            controller: _sessionWorkoutName,
            decoration: const InputDecoration(labelText: 'Workout Name', border: OutlineInputBorder()),
          ),

          const SizedBox(height: 36),
          
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
                            focusNode: exc['focusNode'],
                            decoration: InputDecoration(labelText: 'Exercise ${index + 1}'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => setState(() {
                                if (exc['sets'] > 1) exc['sets']--;
                              }),
                            ),
                            Text('${exc['sets']} Sets'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => exc['sets']++),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
          
          const SizedBox(height: 36),

          Row(
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
                onPressed: _saveSession,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                ),
              )
            ],
          ),
          
          const SizedBox(height: 36), 
        ],
      ),
    );
  }
}