import 'package:robur_fit_x/data/workout_isar.dart';
import 'package:isar/isar.dart';

class WorkoutSet {
  final int reps;
  final double weight;

  // The metric for comparison and progression is the e1RM = Estimated One-Repetition Maximum
  final double e1RM;

  WorkoutSet({
    required this.reps, 
    required this.weight, 
    double? e1RM,
    }): assert(reps >= 0, 'Reps cannot be negative'),
        assert(weight >= 0, 'Weight cannot be negative'),
        e1RM = e1RM ?? weight * (1 + reps / 30);

  IsarWorkoutSet toIsar() {
    return IsarWorkoutSet()
      ..reps = reps
      ..weight = weight
      ..e1RM = e1RM;
  }
}
//---
class Exercise {
  final String name;
  final String groupMuscle;
  final List<WorkoutSet> sets;

  Exercise({required this.name, required this.sets, String? groupMuscle})
    : assert(name != "", 'Exercise must have a name'),
      assert(sets.isNotEmpty, 'Exercise must have at least 1 set'),
      groupMuscle = groupMuscle ?? "FUNCTION TO ASSOCIATE EXERCISE NAME TO MUSCLE GROUP"; // CHANGE

  IsarExercise toIsar(){
    return IsarExercise()
      ..name = name
      ..groupMuscle = groupMuscle
      ..sets = sets.map((element) => element.toIsar()).toList();
  }
}
//---
class Workout {
  final String name;
  final List<Exercise> exercises;
  final DateTime date;
  final double totVolume;
  final int? id;

  Workout({
    this.id,
    required this.name,
    required this.exercises,
    DateTime? date,
    double? totVolume,
  }): assert(name != "", 'Workout must have a name'),
      assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise'),
      date = date ?? DateTime.timestamp(), // CHANGE
      totVolume = totVolume ?? 0; // CHANGE

  IsarWorkout toIsar(){
    return IsarWorkout()
    ..id = id ?? Isar.autoIncrement
    ..name = name
    ..date = date
    ..totVolume = totVolume
    ..exercises = exercises.map((element) => element.toIsar()).toList();
  }

}