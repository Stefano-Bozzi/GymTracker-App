import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'dart:io';

import 'package:robur_fit_x/data/workout.dart';
import 'package:robur_fit_x/data/workout_isar.dart';
import 'package:robur_fit_x/data/workout_template.dart';

void main() {
  late Isar isar;

  // Setup an empty database
  setUp(() async {
    // Downlowad binary files to succesfully make it work on local device
    await Isar.initializeIsarCore(download: true);
    
    // Create a temporary folder, delated later
    final tempDir = await Directory.systemTemp.createTemp('isar_test');

    isar = await Isar.open(
      [IsarWorkoutSchema, IsarTemplateWorkoutSchema],
      directory: tempDir.path,
    );
  });

  // Delate database after every test
  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  test('Workout saving, reading and conversion', () async {
    // 1. SETUP: create domain objects
    // Sets
    WorkoutSet firstSet = WorkoutSet(reps: 6, weight: 28); 
    // e1RM = 28 * (1 + 6/30) = 33.6
    WorkoutSet secondSet = WorkoutSet(reps: 10, weight: 24); 
    // e1RM = 24 * (1 + 10/30) = 32.0

        //template:
    TemplateSet firstTempSet = TemplateSet(); //try null type
    TemplateSet secondTempSet = TemplateSet(reps: 10);
    
    // Exercises
    Exercise chestPress = Exercise(
      name: "Chest Press", 
      groupMuscle: "Chest",
      sets: [firstSet, secondSet]
    );
    Exercise pullDown = Exercise(
      name: "Pull Down", 
      groupMuscle: "Back",
      sets: [firstSet, secondSet]
    );
        //template:
    TemplateExercise chestTempPress = TemplateExercise(name: "Chest Press", sets: [firstTempSet,secondTempSet]);
    TemplateExercise pullTempDown = TemplateExercise(name: "Pull Down", sets: [firstTempSet,secondTempSet]);

    // Workout
    DateTime testDate = DateTime(2026, 3, 15);
    Workout testWorkout = Workout(
      name: "Test Workout",
      date: testDate, // not to depend on timestamp
      totVolume: 2500.5, // random fixed volume to test without volume calculation function
      exercises: [chestPress, pullDown]
    );

        //template:
    TemplateWorkout testTempWorkout = TemplateWorkout(
      name: "Test Template Workout",
      exercises: [chestTempPress, pullTempDown],
      id: 200
      );

    // 2. SAVE INTO ISAR DATABASE
    await isar.writeTxn(() async {
      await isar.isarWorkouts.put(testWorkout.toIsar());
      await isar.isarTemplateWorkouts.put(testTempWorkout.toIsar());
    });

    // 3. READ DATABASE
    final workoutsDalDb = await isar.isarWorkouts.where().findAll();
    final workoutsDalDbTemp = await isar.isarTemplateWorkouts.where().findAll();

    // 4. ASSERT ALL CORRECT
    // --- Database ---
    expect(workoutsDalDb.length, 1, reason: "Only exactly ONE SINGLE WORKOUT");
    
    Workout workoutConvertito = workoutsDalDb.first.toDomain();
    
    // --- Workout ---
    expect(workoutConvertito.id, isNotNull, reason: "Isar MUST HAVE assigned an ID");
    expect(workoutConvertito.name, "Test Workout");
    expect(workoutConvertito.date, testDate, reason: "Date is fixed");
    expect(workoutConvertito.totVolume, 2500.5, reason: "Total volume must be saved");
    expect(workoutConvertito.exercises.length, 2, reason: "must have 2 exercises");

    // --- Exercise 1 (Chest Press) ---
    Exercise firstExc = workoutConvertito.exercises[0];
    expect(firstExc.name, "Chest Press");
    expect(firstExc.groupMuscle, "Chest");
    expect(firstExc.sets.length, 2, reason: "Chest Press must have 2 set");

    // --- Set (Exercise 1) ---
    WorkoutSet exc1Set1 = firstExc.sets[0];
    expect(exc1Set1.reps, 6);
    expect(exc1Set1.weight, 28.0); // Corretto dal tuo 60.0
    expect(exc1Set1.e1RM, closeTo(33.6, 0.01), reason: "e1RM of firstSet must be 33.6");

    WorkoutSet exc1Set2 = firstExc.sets[1];
    expect(exc1Set2.reps, 10);
    expect(exc1Set2.weight, 24.0);
    expect(exc1Set2.e1RM, closeTo(32.0, 0.01), reason: "e1RM of secondSet must be 32.0");

    // --- Exercise 2 (Pull Down) ---
    Exercise secondExc = workoutConvertito.exercises[1];
    expect(secondExc.name, "Pull Down");
    expect(secondExc.groupMuscle, "Back");
    expect(secondExc.sets.length, 2);

    // --- Set (Exercise 2) ---
    WorkoutSet exc2Set1 = secondExc.sets[0];
    expect(exc2Set1.reps, 6);
    expect(exc2Set1.weight, 28.0); // Corretto dal tuo 60.0
    expect(exc2Set1.e1RM, closeTo(33.6, 0.01), reason: "e1RM of firstSet must be 33.6");

    WorkoutSet exc2Set2 = secondExc.sets[1];
    expect(exc2Set2.reps, 10);
    expect(exc2Set2.weight, 24.0);
    expect(exc2Set2.e1RM, closeTo(32.0, 0.01), reason: "e1RM of secondSet must be 32.0");

    // --- TEMPLATE READ & ASSERT ---
    expect(workoutsDalDbTemp.length, 1, reason: "Only exactly ONE SINGLE TEMPLATE WORKOUT");

    TemplateWorkout templateConvertito = workoutsDalDbTemp.first.toDomain();

    expect(templateConvertito.id, 200, reason: "ID must be 200 (set into setup section)");
    expect(templateConvertito.name, "Test Template Workout");
    expect(templateConvertito.exercises.length, 2);

    expect(templateConvertito.exercises[0].sets[0].reps, isNull, reason: "First set must have reps : null");
    expect(templateConvertito.exercises[1].sets[1].reps, 10, reason: "reps : 10");
  });
}