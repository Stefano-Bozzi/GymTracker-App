import 'package:flutter/material.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int selectNavBarState = 0;
  
  @override
  Widget build(BuildContext context) {
    return NavigationBar( //set a list of pages at the bottom. when pressed all the screen change throg the selected page.
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.fitness_center_rounded), label: 'Workouts'),
        ],
        onDestinationSelected: (int value) { // here changes the page selector at the bottom
          setState(() {
            selectNavBarState = value; //set the correct value
          });
        },
        selectedIndex: selectNavBarState  //set the page indicator to the clicked one to visualize the current page
      );
  }
}