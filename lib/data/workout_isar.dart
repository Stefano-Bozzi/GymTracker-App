import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import 'package:robur_fit_x/data/workout.dart';
import 'package:robur_fit_x/data/workout_template.dart';


@collection
class IsarWorkout {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime date;
  late double totVolume;
  late List<IsarExercise> exercises;

  Workout toDomain(){
    return Workout(
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
  late String name;
  late List<IsarTemplateExercise> exercises;


  IsarTemplateWorkout({
    required this.name,
    required this.exercises,
  })  : assert(name != "", 'Workout must have a name'),
        assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise');
  
  TemplateWorkout toDomain(){
    return TemplateWorkout(
      name: name, 
      exercises: exercises.map((e) => e.toDomain()).toList()
      );
  }
}

@embedded
class IsarTemplateExercise {
  late String name;
  late List<IsarTemplateSet> sets;

  IsarTemplateExercise({
    required this.name,
    required this.sets,
  })  : assert(name != "", 'Exercise must have a name'),
        assert(sets.isNotEmpty, 'Exercise must have at least 1 set');
    
  TemplateExercise toDomain(){
    return TemplateExercise(
      name: name, 
      sets: sets.map((element)=>element.toDomain()).toList()
      );
  }
}

@embedded
class IsarTemplateSet {
  late int? reps;

  IsarTemplateSet({this.reps})
      : assert(reps == null || reps >= 0, 'Reps cannot be negative');

  TemplateSet toDomain(){
    return TemplateSet(
      reps: reps
      );
  }
}