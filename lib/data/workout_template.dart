

//________________________________________________________________
// TEMPLATE WORKOUT: classes for saving workout templates
//________________________________________________________________


class TemplateSet {
  final int? reps;

  TemplateSet({this.reps})
      : assert(reps == null || reps >= 0, 'Reps cannot be negative');
}

class TemplateExercise {
  final String name;
  final List<TemplateSet> sets;

  TemplateExercise({
    required this.name,
    required this.sets,
  })  : assert(name != "", 'Exercise must have a name'),
        assert(sets.isNotEmpty, 'Exercise must have at least 1 set');
}

class TemplateWorkout {
  final String name;
  final List<TemplateExercise> exercises;

  TemplateWorkout({
    required this.name,
    required this.exercises,
  })  : assert(name != "", 'Workout must have a name'),
        assert(exercises.isNotEmpty, 'Workout must have at least 1 exercise');
}
