//________________________________________________________________
// TEMPLATE WORKOUT: classes for saving workout templates
//________________________________________________________________

import 'package:robur_fit_x/data/workout_isar.dart';
import 'package:isar/isar.dart';

class TemplateSet {
  final int? reps;

  TemplateSet({this.reps})
      : assert(reps == null || reps >= 0, 'Reps cannot be negative');
      
  IsarTemplateSet toIsar(){
    return IsarTemplateSet()
      ..reps = reps;
  }
}

class TemplateExercise {
  final String name;
  final List<TemplateSet> sets;

  TemplateExercise({
    required this.name,
    required this.sets,
  })  : assert(name != "", 'Exercise must have a name'),
        assert(sets.isNotEmpty, 'Exercise must have at least 1 set');

  IsarTemplateExercise toIsar(){
    return IsarTemplateExercise()
      ..name = name 
      ..sets = sets.map((element)=> element.toIsar()).toList();
  }
}

class TemplateWorkout {
  final int? id;
  final String name;
  final List<TemplateExercise> exercises;

  TemplateWorkout({
    this.id,
    required this.name,
    required this.exercises,
  })  : assert(name != "", 'Workout must have a name'),
        assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise');

  IsarTemplateWorkout toIsar(){
    return IsarTemplateWorkout()
      ..name = name
      ..exercises = exercises.map((element)=>element.toIsar()).toList()
      ..id = id ?? Isar.autoIncrement;
  }
}
