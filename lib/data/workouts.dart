//________________________________________________________________
// WORKOUT: all data classes for storing workout information
//________________________________________________________________
/* Classes Structure:

-Workout
  |- name
  |- exercises (in variable number)
       |- Exercise
            |- name
            |- sets (in variable number)
                 |- Set
                      |- repetitions
                      |- weight

*/

// CLASSES--------------------------------------------------------

/// Number of sets of multiple repetitions of the same exercise.
class WorkoutSet {
  final int reps;
  final double weight;

  WorkoutSet({
    required this.reps,
    required this.weight,
  });

  // Define a method to compare 2 WorkoutSets
  @override
  bool operator ==(Object other) {
    
    if (other is WorkoutSet){

      return ((reps == other.reps)&&(weight == other.weight));

    }
    return false;
  }

  @override
  int get hashCode => Object.hash(reps, weight);
}

/// The specific exercise to be done.
class Exercise {
  final String name;
  final List<WorkoutSet> sets;

  Exercise({
    required this.name,
    required this.sets,
  });

  // Define a method to compare 2 Exercises
  @override
  bool operator ==(Object other) {
    
    if (other is Exercise){

      return ((name == other.name)&&(sets == other.sets));

    }
    return false;
  }

  @override
  int get hashCode => Object.hash(name, sets);

}

/// The entire workout, with exercises, sets, reps and weights.
class Workout {
  final String name;
  final List<Exercise> exercises;

  Workout({
    required this.name,
    required this.exercises,
  });

  // Define a method to compare 2 Workouts
  @override
  bool operator ==(Object other) {
    
    if (other is Workout){

      return ((name == other.name)&&(exercises == other.exercises));

    }
    return false;
  }

  @override
  int get hashCode => Object.hash(name, exercises);

}