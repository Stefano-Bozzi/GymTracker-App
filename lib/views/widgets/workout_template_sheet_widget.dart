import 'package:flutter/material.dart';
import 'package:gym_tracker/data/notifiers.dart';
import 'package:gym_tracker/data/workout_isar.dart';
import 'package:gym_tracker/data/workout_template.dart';
import 'package:gym_tracker/main.dart';
import 'package:gym_tracker/constants/constants.dart';

/// Opens the BottomSheet to create a workout template.
void workoutTemplateCreation(BuildContext context,{IsarTemplateWorkout? templateToEdit}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _CreateTemplateSheet(templateToEdit: templateToEdit),
  );
}

/// Stateful widget for template creation. 
/// Uses a separate State class to preserve user input during UI rebuilds.
class _CreateTemplateSheet extends StatefulWidget {
  final IsarTemplateWorkout? templateToEdit;
  const _CreateTemplateSheet({super.key, this.templateToEdit});

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

  @override
  void initState() {
    super.initState();
    if (widget.templateToEdit != null) {
      _templateWorkoutName.text = widget.templateToEdit!.name;
      
      for (var exc in widget.templateToEdit!.exercises) {
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
    final newFocus = FocusNode(); // create a focus for keyboard
    setState(() {
      _exercises.add({
        'nameController': TextEditingController(),
        'sets': 1,
        'focusNode': newFocus,
      });
    });
    newFocus.requestFocus(); // keyboard focus go to new focus
  }

  /// Show an error message to ensure all fields are specified during workout creation
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Attention", style: TextStyle(color: AppColors.alert(context))),
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

  // Creates domain objects and saves to Isar
  
  /// Create TemplateWorkout from a current sheet state
  TemplateWorkout createTemplateWorkout() {
    String templateName = _templateWorkoutName.text;
    List<TemplateExercise> exercises = [];
    for (var exc in _exercises) {
      List<TemplateSet> templateSet = List.generate(exc['sets'], (index) => TemplateSet(reps: null));
      exercises.add(TemplateExercise(name: exc['nameController'].text, sets: templateSet));
    }
    
    if (widget.templateToEdit != null) {
      return TemplateWorkout(id: widget.templateToEdit!.id, name: templateName, exercises: exercises);
    } else {
      return TemplateWorkout(name: templateName, exercises: exercises);
    }
  }

  /// Save a Template workout in smartphone storage
  Future<void> _saveTemplate() async{
    // check before saving
    if (_templateWorkoutName.text.trim().isEmpty) {
      _showError("Workout Template MUST have a name");
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
    TemplateWorkout finalWorkout = createTemplateWorkout();
    await isar.writeTxn(() async {
      await isar.isarTemplateWorkouts.put(finalWorkout.toIsar());
    });

    refreshWorkoutPageNotifier.value = !refreshWorkoutPageNotifier.value;
    // Close popup
    Navigator.pop(context);

    // Successfully saving Message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Workout Template Successfully Saved"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Delate unnecessary information when exit
  @override
  void dispose() {
    _templateWorkoutName.dispose();
    for (var exc in _exercises) {
      exc['nameController'].dispose();
      exc['focusNode'].dispose();
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
                            focusNode: exc['focusNode'],
                            decoration: InputDecoration(labelText: 'Exercise ${index + 1}'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Sets counter
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

                            const SizedBox(width: 8),
                            // Delete exercise button
                                IconButton(
                              icon: Icon(Icons.delete, color: AppColors.alert(context),),
                                  onPressed: () => setState(() {
                                    _exercises.removeAt(index);
                                  }),
                                ),
                          ],
                        )
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
              onPressed: _saveTemplate,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              ),
            )
          ],
        ),
        
        const SizedBox(height: 36), // Bottom margin
      ],
    ),
  );
 }
}