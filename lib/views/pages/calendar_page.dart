//________________________________________________________________
// CALENDAR: page that contains the workout history
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:gym_tracker/main.dart';
import 'package:gym_tracker/data/notifiers.dart';
import 'package:gym_tracker/data/workout_isar.dart';
import 'package:gym_tracker/views/widgets/workout_session_sheet_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState(); 
}

class _CalendarPageState extends State<CalendarPage>{

  List<IsarWorkout> _session = [];

  @override
  void initState() {
    super.initState();
    
    _loadSession();

    // refresh page if notifier change
    refreshCalendarPageNotifier.addListener(_loadSession);
  }

  /// Find all Session and load in reversed-chronological order
  Future<void> _loadSession() async {
    // find all
    final workoutFromDB = await isar.isarWorkouts.where().findAll();

    setState(() {
      // reverse the order
      _session = workoutFromDB.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My History'),
      ),
      // if empty list show message
      body: _session.isEmpty
          ? const Center(child: Text("No sessions yet. Tap the + button to track your first workout!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _session.length,
              itemBuilder: (context, index) {
                final session = _session[index];
                
                // Graphic and Actions
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(session.name)
                        ),
                        const SizedBox(width: 16),
                        // Sets counter
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 185, 35, 35),),
                              onPressed: () => deleteIsarElement(isar, isar.isarWorkouts, session.id, refreshWorkoutPageNotifier, context)
                            ),
                              const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => 
                              workoutSessionCreation(context,sessionToEdit: session)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}