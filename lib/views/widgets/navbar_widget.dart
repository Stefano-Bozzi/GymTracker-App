//________________________________________________________________
// NAVBAR: widget for custom Navigation Bar
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:gym_tracker/data/notifiers.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, selectedPage, child) {
      return NavigationBar( //set a list of pages at the bottom. when pressed all the screen change throg the selected page.
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.fitness_center_rounded), label: 'Workouts'),
        ],
        onDestinationSelected: (int value) { // here changes the page selector at the bottom
        selectedPageNotifier.value = value;
        },
        selectedIndex: selectedPage  //set the page indicator to the clicked one to visualize the current page
      );
    },);
  }
}