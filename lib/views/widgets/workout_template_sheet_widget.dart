import 'package:flutter/material.dart';
import 'package:robur_fit_x/data/notifiers.dart';
import 'package:robur_fit_x/data/workout_isar.dart';
import 'package:robur_fit_x/main.dart';

/// Opens the BottomSheet to create a workout template.
void workoutTemplateCreation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _CreateTemplateSheet(),
  );
}

/// Stateful widget for template creation. 
/// Uses a separate State class to preserve user input during UI rebuilds.
class _CreateTemplateSheet extends StatefulWidget {
  const _CreateTemplateSheet();

  // Instantiates and links the mutable state to this widget.
  @override
  State<_CreateTemplateSheet> createState() => _CreateTemplateSheetState();
}

/// State for [`_CreateTemplateSheet`] that preserves user input across rebuilds.
/// Holds the template name controller and a list of exercises
/// (each with its own controller and set count).
class _CreateTemplateSheetState extends State<_CreateTemplateSheet> {
  final TextEditingController _templateWorkoutName = TextEditingController();
  final List<Map<String, dynamic>> _exercises = [];
}