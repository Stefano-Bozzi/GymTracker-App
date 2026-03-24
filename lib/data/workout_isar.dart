import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'package:robur_fit_x/data/workout.dart';
import 'package:robur_fit_x/data/workout_template.dart';
import 'package:robur_fit_x/main.dart';

part 'workout_isar.g.dart';

@collection
class IsarWorkout {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime date;
  late double totVolume;
  late List<IsarExercise> exercises;

  Workout toDomain(){
    return Workout(
      id : id,
      name: name, 
      date : date,
      totVolume: totVolume,
      exercises: exercises.map((element)=>element.toDomain()).toList()
    );
  }
}

@embedded
class IsarExercise {
  late String name;
  late List<IsarWorkoutSet> sets;
  late String groupMuscle;

  Exercise toDomain(){
    return Exercise(
      name: name, 
      groupMuscle: groupMuscle,
      sets: sets.map((element)=>element.toDomain()).toList()
    );
  }
}

@embedded
class IsarWorkoutSet {
  late int reps;
  late double weight;
  late double e1RM;


  WorkoutSet toDomain(){
    return WorkoutSet(
      reps: reps, 
      weight: weight,
      e1RM: e1RM
      );
  }
}

// Template ----

@collection
class IsarTemplateWorkout {
  Id id = Isar.autoIncrement;
  late String name;
  late List<IsarTemplateExercise> exercises;

  TemplateWorkout toDomain(){
    return TemplateWorkout(
      id: id,
      name: name, 
      exercises: exercises.map((e) => e.toDomain()).toList()
      );
  }
}

@embedded
class IsarTemplateExercise {
  late String name;
  late List<IsarTemplateSet> sets;

  TemplateExercise toDomain(){
    return TemplateExercise(
      name: name, 
      sets: sets.map((element)=>element.toDomain()).toList()
      );
  }
}

@embedded
class IsarTemplateSet {
  int? reps;

  TemplateSet toDomain(){
    return TemplateSet(
      reps: reps
      );
  }
}

/// Delate a general Isar Element
Future<void> deleteIsarElement<T>(
  Isar db,
  IsarCollection collection,
  int id,
  ValueNotifier<bool> notifier,
  BuildContext context,
  ) async {

  await db.writeTxn(() async {
    // try to delate isar obj with current id
    final success = await collection.delete(id);
    
    if (success) {
      // change notifier to refresh pages
      notifier.value = !notifier.value;
    }
  });

  // Feedback message
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Succesfully Deleted")),
    );
  }
} 