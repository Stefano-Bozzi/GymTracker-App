import 'package:flutter/material.dart';
import 'package:gym_tracker/data/notifiers.dart';
import 'package:gym_tracker/data/workout_isar.dart';
import 'package:gym_tracker/data/workout.dart';
import 'package:gym_tracker/main.dart';
import 'package:isar_community/isar.dart';
import 'package:gym_tracker/constants/constants.dart';

///Format weight display
String formatWeight(double weight) {
  return weight.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
}

///CHeck if weight is in kg
bool isKg(String val){
  return (val == 'kg' ? true : false);
}

/// Display weight in selected unit of measurement (kg or lb)
double toDisplayWeight(double weightKg){
  double weight = weightKg;

  return (isKg(weightNotifier.value) ? weight : weight*kgToLb);
}

/// Save weight to isar DB always in kg
double toDBWeight(double inputWeight){
  double weight = inputWeight;

  return (isKg(weightNotifier.value) ? weight : weight/kgToLb);
}

/// Check for past same exercise to make comparison
Future<IsarExercise?> getLastExercise(String name, [int? currentWorkoutId]) async {
  // Build the base query searching for the specific exercise name
  var filterQuery = isar.isarWorkouts.filter().exercisesElement((q) => q.nameEqualTo(name));
  
  // If we are editing an existing session, we must EXCLUDE it from the search
  if (currentWorkoutId != null) {
    filterQuery = (filterQuery.idLessThan(currentWorkoutId));
  }

  // Get the most recent one
  final workout = await filterQuery.sortByDateDesc().findFirst();

  if (workout == null) {
    return null;
  } else {
    return workout.exercises.firstWhere((e) => e.name == name);
  }
}


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
           padding: EdgeInsets.all(16.0),
           child: Center(child: Text("No templates found. Go to Workouts to create one!",textAlign: TextAlign.center)),
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
    _initDataSync();
    _loadPastDataAsync();
  }
  void _initDataSync(){
    // A. if modify an existing session
    if (widget.sessionToEdit != null) {
      _sessionWorkoutName.text = widget.sessionToEdit!.name;
      for (var exc in widget.sessionToEdit!.exercises) {
        List<Map<String, dynamic>> _sets = [];
        for (var s in exc.sets) {
          _sets.add({
            'weightController': TextEditingController(text: formatWeight(toDisplayWeight(s.weight))),
            'reps': s.reps,
            'hintWeight' : '...',
            'pastE1RM': null,
          });
        }
        _exercises.add({
          'nameController': TextEditingController(text: exc.name),
          'sets': _sets,
          'focusNode': FocusNode(),
        });
      }
    } 
    // B. if creating new one
    else if (widget.baseTemplate != null) {
      _sessionWorkoutName.text = widget.baseTemplate!.name;
      for (var exc in widget.baseTemplate!.exercises) {
        List<Map<String, dynamic>> _sets = [];
        for (var s in exc.sets) {
          _sets.add({
            'weightController': TextEditingController(),
            'reps': 1,
            'hintWeight' : '...',
            'pastE1RM': null,
          });
        }
        _exercises.add({
          'nameController': TextEditingController(text: exc.name),
          'sets': _sets,
          'focusNode': FocusNode(),
        });
      }
    }
  }

  /// Function to pass data to fill field with past data as decoration and calculate statistics comparison
  Future<void> _loadPastDataAsync() async{
    // if the current session is in modify mode i need to exclude current session from search in past statistics.
    int? excludeId = widget.sessionToEdit?.id;

    for (var exc in _exercises) {
      String excName = exc['nameController'].text;
      if (excName.isEmpty) continue;

      // If this exercise has a name find a past one
      IsarExercise? pastExc = await getLastExercise(excName, excludeId);

      if (pastExc != null && mounted) { //here mounted is a default bool var existing because this current
                                        // class is created expandig State (base class for stateful widget)
                                        // it says if the widget is on screen.

        //alert on graphics
        setState(() {
          var sets = exc['sets'] as List<Map<String, dynamic>>;

          // here the logic: if the user create from template insert past reps and hint weight,
          // if the user modify session insert only hint weight (visible only if deleted all text in weight field)
          for (int i =0; i < sets.length; i++){
            if (i < pastExc.sets.length){
              IsarWorkoutSet pastSet = pastExc.sets[i];
              double displayWeight = toDisplayWeight(pastSet.weight);
              sets[i]['hintWeight'] = formatWeight(displayWeight);
              sets[i]['pastE1RM'] = pastSet.e1RM;
              if (widget.sessionToEdit == null){
                sets[i]['reps'] = pastSet.reps;
              }
            }
          }
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
        'sets': [
          {
            'weightController': TextEditingController(),
            'reps': 1,
            'hintWeight' : '...',
            'pastE1RM':null,
          }
        ],
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
      List<WorkoutSet> sessionSets = List.generate(exc['sets'].length, (index) {
        var currentSet = exc['sets'][index];
        double weightValue = toDBWeight(double.tryParse(currentSet['weightController'].text.replaceAll(',', '.')) ?? 0.0);
        
        return WorkoutSet(reps: currentSet['reps'], weight: weightValue);
      });
      exercises.add(Exercise(name: exc['nameController'].text.trim(), groupMuscle: "", sets: sessionSets));
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
      const SnackBar(
        content: Text("Workout Session Successfully Saved"),
        duration: Duration(seconds: 1),
    ),
    );
  }

  @override
  void dispose() {
    _sessionWorkoutName.dispose();
    for (var exc in _exercises) {
      exc['nameController'].dispose();
      exc['focusNode'].dispose();
      for (var s in exc['sets']) {
        s['weightController'].dispose();
      }
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
                    child: Column(
                      children:[
                        Row(
                          children: [
                            Expanded(child: 
                              TextField(
                                controller: exc['nameController'],
                                focusNode: exc['focusNode'],
                                decoration: InputDecoration(labelText: 'Exercise ${index + 1}'),
                              ),
                              ),
                          // Delete current exercise
                                IconButton(
                                  icon: Icon(Icons.delete, color: AppColors.alert(context),),
                                  onPressed: () => setState(() {
                                    _exercises.removeAt(index);
                                  }),
                                ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // --- Label Row ---
                        Row(
                          children: [
                            // Set number
                                Expanded(
                                  flex: 2,
                                  child: Opacity(opacity: 0.0,
                                  child: Text('Set 0', style: const TextStyle(fontWeight: FontWeight.bold)),
                                )),
                                
                                // Weight input (Kg)
                                Expanded(
                                  flex: 4,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown, // scale down if necessary
                                    child: Text(
                                      isKg(weightNotifier.value) ? 'Weight (kg)' : 'Weight (lb)',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1, // only one line
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                
                                // Fixed container centered with reps number
                                SizedBox(
                                  width: 116, //20+48+48
                                  child: Center(
                                    child: Text('Reps', style:const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                
                                const SizedBox(width: 4), 

                                //arrow for progress
                                const Opacity(opacity: 0.0, child: Icon(Icons.abc_outlined)),
                                const SizedBox(width: 4), 
                                // Delete current set
                                const Opacity(opacity: 0.0,child:IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: null,
                                ),),
                              ],
                        ),
                        
                        // a row for each Set
                        // ... expand the list into the Column
                        ...List.generate(exc['sets'].length, (setIndex) {
                          var currentSet = exc['sets'][setIndex];

                          // progress arrow logic
                          double pastE1RM = currentSet['pastE1RM'] ?? 0.0;
                          String currentWeightText = currentSet['weightController'].text.trim();
                          
                          Icon iconForProgress;

                          // if field is empty, shows = (does not calculate negative progress)
                          if (currentWeightText.isEmpty) {
                            iconForProgress = Icon(Icons.drag_handle_rounded, color: AppColors.progressEqual(context));
                          } else {
                            // Calculate true progress only if field is actively filled
                            double currentWeight = toDBWeight(double.tryParse(currentWeightText.replaceAll(',', '.')) ?? 0.0);
                            double currentE1RM = currentWeight * (1 + currentSet['reps'] / 30);

                            double progress = currentE1RM - pastE1RM;
                            
                            if (progress > 0) {
                              iconForProgress = Icon(Icons.keyboard_double_arrow_up_rounded, color:AppColors.progressUp(context));
                            } else if (progress < 0) {
                              iconForProgress = Icon(Icons.keyboard_double_arrow_down_rounded, color:AppColors.progressDown(context));
                            } else {
                              iconForProgress = Icon(Icons.drag_handle_rounded, color:AppColors.progressEqual(context));
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                // Set number
                                Expanded(
                                  flex: 2,
                                  child: Text('Set ${setIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                
                                // Weight input (Kg)
                                Expanded(
                                  flex: 4,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: currentSet['weightController'],
                                    onChanged: (val) => setState(() {}), // e1rm calculation upgrade withoud need for confirm
                                    decoration: InputDecoration(
                                      hintText: currentSet['hintWeight'],
                                      border: OutlineInputBorder(),
                                      isDense: true, // more compact text
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                
                                // Reps input
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => setState(() {
                                    if (currentSet['reps'] > 1)
                                      currentSet['reps']--;
                                  }),
                                ),
                                // Fixed container for 2 digits
                                SizedBox(
                                  width: 20,
                                  child: Center(
                                    child: Text('${currentSet['reps']}'),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () =>
                                      setState(() => currentSet['reps']++),
                                ),
                                const SizedBox(width: 4), 

                                //arrow for progress
                                iconForProgress,
                                const SizedBox(width: 4), 
                                // Delete current set
                                IconButton(
                                  icon: Icon(Icons.delete, color: AppColors.alert(context),),
                                  onPressed: () => setState(() {
                                    if (exc['sets'].length > 1) exc['sets'].removeAt(setIndex);
                                  }),
                                ),
                              ],
                            ),
                          );
                        }),
                        
                        TextButton.icon(
                          onPressed: () => setState(() {
                            exc['sets'].add({
                              'weightController': TextEditingController(),
                              'reps': 1,
                              'hintWeight' : '...',
                              'pastE1RM':null,
                            });
                          }),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Set"),
                        ),
                      ]
                    )
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