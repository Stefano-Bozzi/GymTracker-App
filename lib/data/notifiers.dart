//________________________________________________________________
// NOTIFIERS: all variables that notify changes in some widget
//________________________________________________________________

import 'package:flutter/material.dart';

// NavBar notifier for Home-Calendar-Workout pages
ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);

// Refresh Workout Page when added a new template
ValueNotifier<bool> refreshWorkoutPageNotifier = ValueNotifier(false);

// Refresh Calendar Page when added a new session
ValueNotifier<bool> refreshCalendarPageNotifier = ValueNotifier(false);

// Change theme
ValueNotifier<String> themeNotifier = ValueNotifier('D');