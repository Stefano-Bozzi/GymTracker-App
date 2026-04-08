//________________________________________________________________
// WIDGET-TREE: Principal Container for Scaffold and app structure
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:gym_tracker/constants/constants.dart';
import 'package:gym_tracker/data/notifiers.dart';
import 'package:gym_tracker/views/pages/calendar_page.dart';
import 'package:gym_tracker/views/pages/home_page.dart';
import 'package:gym_tracker/views/pages/workout_page.dart';
import 'package:gym_tracker/views/widgets/appdrawer_widget.dart';
import 'package:gym_tracker/views/widgets/navbar_widget.dart';
import 'package:gym_tracker/views/widgets/dinamicfab_widget.dart';
import 'package:gym_tracker/views/widgets/onboarding_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages= [
  // A list of all pages accessible from the NavBar.
  HomePage(),
  CalendarPage(),
  WorkoutPage(),
];

class WidgetTree extends StatefulWidget {
  // WidgetTree acts as the main container and structural backbone of the app.
  // It is STATEFUL NOW BECAUSE OF THE TUTORIAL, the body also changes based on external state (selectedPageNotifier).
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  void initState() {
    super.initState();
    // PopUp guide on starting, check if first starting, otherwise skip
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  Future<void> _checkFirstLaunch() async {
    // Obtain preferences
    final prefs = await SharedPreferences.getInstance();
    
    // if flag does not exist is first start
    final hasSeenTutorial = prefs.getBool('hasSeenTutorial') ?? false;

    if (!hasSeenTutorial) {
      // if not seen yet show tutorial
      if (mounted) {
        _showOnboarding();
      }
      await prefs.setBool('hasSeenTutorial', true);
    }
  }

  void _showOnboarding() {
    showDialog(
      context: context,
      barrierDismissible: false, // User Must interact with popup
      builder: (context) => const OnboardingDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // all Scaffold is rebuild when user interact.
    // this is optimize checking only for changes in widget tree.
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          // The Scaffold provides the standard visual structure for the app
          // (is in WidgetTree and not in MaterialApp to minimizing rebuilds of
          // the MaterialApp's global configuration).

          // top app bar
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(appName),
          ),

          // drawer
          drawer: const AppDrawerWidget(), //side list of options
          // navigation bar
          bottomNavigationBar: const NavBarWidget(),

          // current page
          body: pages.elementAt(selectedPage),

          // floating action button that change with current page
          floatingActionButton: const DinamicFAB(),

          // Mandatory for FAB alignment
          //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}