//________________________________________________________________
// DINAMIC FAB: widget for custom Dinamic Floating Action Button
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:robur_fit_x/data/notifiers.dart';

// --- Dynamic FAB Widget ---
// Change action, text and icon accordingly to the page selected in navBar

class DinamicFAB extends StatelessWidget {
  const DinamicFAB({super.key});
  
  // --- Dynamic FAB Helper Functions ---

  // Determines the text label for the Floating Action Button based on the current page index.
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

  // Determines the icon for the Floating Action Button based on the current page index.
  IconData getFabIcon(int selectedPage) {
    switch (selectedPage) {
      case 0:
        return Icons.play_arrow_rounded; // Start/Session icon
      case 1:
        return Icons.play_arrow_rounded; // Add a routine/workout
      case 2:
        return Icons.add_box_rounded; // Add a calendar item
      default:
        return Icons.add;
    }
  }

  // Defines the specific action to be executed when the FAB is pressed.
  void handleFabPress(BuildContext context, int selectedPage) {
    // You use the 'selectedPage' index to decide which logic to execute.
    String actionMessage;

    switch (selectedPage) {
      case 0:
        actionMessage = 'Starting a new Training Session...';
        // ...
        break;
      case 1:
        actionMessage = 'Starting a new Training Session...';
        // ...
        break;
      case 2:
        actionMessage = 'Opening New Activity form...';
        // ...
        break;
      default:
        actionMessage = 'Undefined action.';
    }

    // Display a SnackBar for testing/debugging the action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(actionMessage),
      ),
    );
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
