import 'package:flutter/material.dart';
import 'package:robur_fit_x/data/notifiers.dart';
import '../main.dart';
import 'package:robur_fit_x/views/pages/calendar_page.dart';
import 'package:robur_fit_x/views/pages/home_page.dart';
import 'package:robur_fit_x/views/pages/workout_page.dart';

List<Widget> pages= [
  HomePage(),
  CalendarPage(),
  WorkoutPage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(appName),
      ),
      body: ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, selectedPage, child) {
        return pages.elementAt(selectedPage);
      },),
    );
  }
}