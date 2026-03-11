class WorkoutSet {
  final int reps;
  final double weight;

  // The metric for comparison and progression is the e1RM = Estimated One-Repetition Maximum
  final double e1RM;

  WorkoutSet({required this.reps, required this.weight})
    : assert(reps >= 0, 'Reps cannot be negative'),
        assert(weight >= 0, 'Weight cannot be negative'),
        e1RM = weight * (1 + reps / 30);

}
//---
class Exercise {
  final String name;
  final String groupMuscle;
  final List<WorkoutSet> sets;

  Exercise({required this.name, required this.sets})
    : assert(name != "", 'Exercise must have a name'),
      assert(sets.isNotEmpty, 'Exercise must have at least 1 set'),
      groupMuscle = "FUNCTION TO ASSOCIATE EXERCISE NAME TO MUSCLE GROUP";
}
//---
class Workout {
  final String name;
  final List<Exercise> exercises;

  Workout({
    required this.name,
    required this.exercises,
  }): assert(name != "", 'Workout must have a name'),
      assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise');

}