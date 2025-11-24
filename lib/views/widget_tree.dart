//________________________________________________________________
// WIDGET-TREE: Principal Container for Scaffold and app structure
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:robur_fit_x/constants/constants.dart';
import 'package:robur_fit_x/data/notifiers.dart';
import 'package:robur_fit_x/views/pages/calendar_page.dart';
import 'package:robur_fit_x/views/pages/home_page.dart';
import 'package:robur_fit_x/views/pages/workout_page.dart';
import 'package:robur_fit_x/views/widgets/appdrawer_widget.dart';
import 'package:robur_fit_x/views/widgets/navbar_widget.dart';

List<Widget> pages= [
  // A list of all pages accessible from the NavBar
  HomePage(),
  CalendarPage(),
  WorkoutPage(),
];

class WidgetTree extends StatelessWidget {
  // WidgetTree acts as the main container and structural backbone of the app.
  // It is StatelessWidget as its structure (Scaffold, AppBar, etc.) is fixed, 
  // and only its content (the 'body') changes based on external state (selectedPageNotifier).
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The Scaffold provides the standard visual structure for the app 
      // (is in WidgetTree and not in MaterialApp to minimizing rebuilds of 
      // the MaterialApp's global configuration).
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(appName),
      ),
      drawer: AppDrawerWidget(), //side list of options
      bottomNavigationBar: NavBarWidget(),
      body: ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, selectedPage, child) {
        // the body changes page according to selected page in navBar
        return pages.elementAt(selectedPage);
      },),
    );
  }
}