//________________________________________________________________
// DINAMIC FAB: widget for custom Dinamic Floating Action Button
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:robur_fit_x/data/notifiers.dart';
import 'package:robur_fit_x/views/widgets/workout_template_sheet_widget.dart';
import 'package:robur_fit_x/views/widgets/workout_session_sheet_widget.dart';
import 'package:robur_fit_x/main.dart';

class DinamicFAB extends StatelessWidget {
  const DinamicFAB({super.key});
  
  // --- Dynamic FAB Helper Functions ---
  /// Determines FAB text label based on current page index.
  String getFabLabel(int selectedPage) {
    switch (selectedPage) {
      case 0:
        // Home Page
        return 'New Session';
      case 1:
        // Calendar Page
        return 'New Session';
      case 2:
        // Workout Page
        return 'New Workout';
      default:
        return '';
    }
  }

  /// Determines FAB icon based on current page index.
  IconData getFabIcon(int selectedPage) {
    switch (selectedPage) {
      case 0:
        return Icons.play_arrow_rounded;
      case 1:
        return Icons.play_arrow_rounded;
      case 2:
        return Icons.add_box_rounded;
      default:
        return Icons.add;
    }
  }

  // Defines the specific action to be executed when the FAB is pressed.
  void handleFabPress(BuildContext context, int selectedPage) {
    // You use the 'selectedPage' index to decide which logic to execute.

    switch (selectedPage) {
      case 0:
        showAllTemplates(context);
        break;
      case 1:
        showAllTemplates(context);
        break;
      case 2:
        workoutTemplateCreation(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, selectedPage, child) {
    return FloatingActionButton.extended(
          // The onPressed function calls the dynamic handler
          onPressed: () => handleFabPress(context, selectedPage),

          // The icon is dynamically chosen
          icon: Icon(getFabIcon(selectedPage)),

          // The label is dynamically chosen
          label: Text(getFabLabel(selectedPage)),

          tooltip: getFabLabel(selectedPage), // 
        );
    });
  }
}
