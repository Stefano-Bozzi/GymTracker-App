//________________________________________________________________
// CALENDAR: page that contains the workout history
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:gym_tracker/main.dart';
import 'package:gym_tracker/data/notifiers.dart';
import 'package:gym_tracker/data/workout_isar.dart';
import 'package:gym_tracker/views/widgets/workout_session_sheet_widget.dart';
import 'package:gym_tracker/constants/constants.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState(); 
}

class _CalendarPageState extends State<CalendarPage>{

  List<IsarWorkout> _session = [];

  // to avoid empty message before all sessions are loaded
  bool _isLoading = true;
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

    // set loading flag false
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My History'),
      ),
      // if empty list show message
      body: _session.isEmpty
          // avoid writing message for empty page if not finished loading.
          ? (_isLoading == false ? const Center(child: Text("No sessions yet. Tap the + button to track your first workout!")) :const Center(child: Text(""))) 
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(session.name),
                              Text(session.date.toString().substring(0, 16), style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Sets counter
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: AppColors.alert(context),),
                              onPressed: () => deleteIsarElement(isar, isar.isarWorkouts, session.id, refreshCalendarPageNotifier, context)
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