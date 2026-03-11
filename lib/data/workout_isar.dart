import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

@collection
class IsarWorkout {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime date;
  late double totVolume;
  late List<IsarExercise> exercises;
}

@embedded
class IsarExercise {
  late String name;
  late List<IsarWorkoutSet> sets;
  late String groupMuscle;
}

@embedded
class IsarWorkoutSet {
  late int reps;
  late double weight;
  late double e1RM;
}

// Template ----

@collection
class IsarTemplateWorkout {
  final String name;
  final List<IsarTemplateExercise> exercises;


  IsarTemplateWorkout({
    required this.name,
    required this.exercises,
  })  : assert(name != "", 'Workout must have a name'),
        assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise');
}

@embedded
class IsarTemplateExercise {
  final String name;
  final List<IsarTemplateSet> sets;

  IsarTemplateExercise({
    required this.name,
    required this.sets,
  })  : assert(name != "", 'Exercise must have a name'),
        assert(sets.isNotEmpty, 'Exercise must have at least 1 set');
}

@embedded
class IsarTemplateSet {
  final int? reps;

  IsarTemplateSet({this.reps})
      : assert(reps == null || reps >= 0, 'Reps cannot be negative');
}