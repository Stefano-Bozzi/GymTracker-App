//________________________________________________________________
// WORKOUT: all data classes for storing workout information
//________________________________________________________________
/* Classes Structure:

classes for storing data
-Workout
  |- name
  |- exercises (in variable number)
       |- Exercise
            |- name
            |- sets (in variable number)
                 |- Set
                      |- repetitions
                      |- weight

classes for saving workout template
-TemplateWorkout
  |- name
  |- exercises (in variable number)
       |- TemplateExercise
            |- name
            |- sets (in variable number)
                 |- TemplateSet
                      |- repetitions
*/

// CLASSES--------------------------------------------------------

/// Number of sets of multiple repetitions of the same exercise.
///
/// Automatically computes the **e1RM** (*Estimated 1-Rep Max*):
/// `e1RM = weight * (1 + reps / 30)`.
///
/// ### Fields
/// - `reps`: repetitions (>= 0)
/// - `weight`: weight (>= 0)
/// - `e1RM`: estimated one-rep max
///
/// ### Requirements
/// - `reps` and `weight` must be >= 0 (assert).
///
/// ### Comparison
/// - `==` → equality based on `reps` and `weight`
/// - `compareTo` → comparison based on `e1RM` (for sorting and progression)
class WorkoutSet implements Comparable<WorkoutSet> {
  final int reps;
  final double weight;

  // The metric for comparison and progression is the e1RM = Estimated One-Repetition Maximum
  final double e1RM;

  WorkoutSet({required this.reps, required this.weight})
    : assert(reps >= 0, 'Reps cannot be negative'),
        assert(weight >= 0, 'Weight cannot be negative'),
        e1RM = weight * (1 + reps / 30);

  // Define a method to compare 2 WorkoutSets for <,=,>
  @override
  int compareTo(WorkoutSet other) {
    return e1RM.compareTo(other.e1RM);
  }
}

/// The specific exercise to be done consisting of one or more workout sets.
///
/// ### Fields
/// - `name`: exercise name (non-empty)
/// - `sets`: list of performed sets (must have ≥ 1)
/// - `orderedSets`: sets sorted by e1RM descending (auto-generated)
///
/// ### Requirements
/// - `name` must not be empty
/// - `sets` must contain at least one `WorkoutSet`
///
/// ### Comparison
/// - Can compare two exercises **only if they have the same name**
/// - `compareTo` compares exercises by sorting their sets by e1RM and
///   comparing them pairwise  
///   → if all sets are equal, the exercise with more sets wins
///
/// Throws:
/// - `ArgumentError` if trying to compare exercises with different names
class Exercise implements Comparable<Exercise> {
  final String name;
  final List<WorkoutSet> sets;
  final List<WorkoutSet> orderedSets;

  // Define a method to check if comparison is possible
  bool isComparable(Exercise other) {
    if (name == other.name) {
      return true;
    }
    return false;
  }

  Exercise({required this.name, required this.sets})
    : assert(name != "", 'Exercise must have a name'),
      assert(sets.isNotEmpty, 'Exercise must have at least 1 set'),
      orderedSets = List<WorkoutSet>.from(
        sets
            .toList() // need a copy of sets
          ..sort(
            (a, b) => b.e1RM.compareTo(a.e1RM),
          ), // this modify the list in place
      );

  // Define a method to compare 2 WorkoutSets for <,=,>
  @override
  int compareTo(Exercise other) {
    if (!isComparable(other)) {
      // Rais Error
      throw ArgumentError(
        'Cannot compare performance between different exercises: "$name" and "${other.name}".',
      );
    }
    List<WorkoutSet> listA = orderedSets;
    List<WorkoutSet> listB = other.orderedSets;

    // Find minimum lenght, if all sets are =, wins wich has more sets
    final int minLength = (listA.length < listB.length)
        ? listA.length
        : listB.length;

    for (int i = 0; i < minLength; i++) {
      final WorkoutSet setA = listA[i];
      final WorkoutSet setB = listB[i];

      // Check for winner wrt e1RM
      final int comparison = setA.compareTo(setB);

      if (comparison != 0) {
        // If yes: return the comparison
        return comparison;
      }
    }
    // If all sets are =, return the exercise with more sets
    return listA.length.compareTo(listB.length);
  }
}

/// The entire workout, with exercises, sets, reps and weights.
///
/// A workout has a `name` and a list of `Exercise` entries, each made of
/// sets, reps, and weights.
///
/// ### Fields
/// - `name`: workout name (non-empty)
/// - `exercises`: list of exercises (must have ≥ 1)
///
/// ### Requirements
/// - `name` must not be empty
/// - `exercises` must contain at least one `Exercise`
class Workout {
  final String name;
  final List<Exercise> exercises;

  Workout({
    required this.name,
    required this.exercises,
  }): assert(name != "", 'Workout must have a name'),
      assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise');

}


//________________________________________________________________
// TEMPLATE WORKOUT: classes for saving workout templates
//________________________________________________________________

/// A template for a single set inside a workout template.
/// Unlike WorkoutSet, this does NOT require weight or precise reps.
///
/// Fields:
/// - reps: optional indication of planned reps (nullable)
///
/// Requirements:
/// - reps >= 0 if provided
class TemplateSet {
  final int? reps;

  TemplateSet({this.reps})
      : assert(reps == null || reps >= 0, 'Reps cannot be negative');
}


/// A template for an exercise inside a workout template.
///
/// Fields:
/// - name: exercise name (non-empty)
/// - sets: list of TemplateSet (must have ≥ 1)
///
/// Requirements:
/// - name must not be empty
/// - sets must contain at least one TemplateSet
class TemplateExercise {
  final String name;
  final List<TemplateSet> sets;

  TemplateExercise({
    required this.name,
    required this.sets,
  })  : assert(name != "", 'Exercise must have a name'),
        assert(sets.isNotEmpty, 'Exercise must have at least 1 set');
}


/// A workout template, containing only the structure of the workout,
/// not the real performance values.
///
/// Fields:
/// - name: template name (non-empty)
/// - exercises: list of TemplateExercise (must have ≥ 1)
///
/// Requirements:
/// - name must not be empty
/// - exercises must contain at least 1 TemplateExercise
class TemplateWorkout {
  final String name;
  final List<TemplateExercise> exercises;

  TemplateWorkout({
    required this.name,
    required this.exercises,
  })  : assert(name != "", 'Workout must have a name'),
        assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise');
}
