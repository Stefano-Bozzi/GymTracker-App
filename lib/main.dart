//----------------------------------------------------------------
// IMPORT AND OVERALL VARIABLES DEFINITION
//----------------------------------------------------------------

import 'package:flutter/material.dart';                   // Import Flutter Material library for UI widgets and themes                                                          // rootBundel is needet to have access to "-access" files
import 'package:robur_fit_x/views/widget_tree.dart';
import 'package:robur_fit_x/views/widgets/appdrawer_widget.dart';
import 'package:robur_fit_x/views/widgets/navbar_widget.dart';

const String appName = "RoburFitX";


// Define Colors for Light and Dark mode
final lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF607D8B),   // Define primary color
  onPrimary: Colors.white,      // Define color for text/icons on primary color
  secondary: Color(0xFF546E7A),
  onSecondary: Colors.white,
  error: Color(0xFFB00020),
  onError: Colors.white,
  surface: Colors.white,        // Define surface color (e.g., card backgrounds)
  onSurface: Color(0xFF1C1B1F), // Define color for text/icons on surface color
);

final darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF607D8B),
  onPrimary: Color(0xFF121212),
  secondary: Color(0xFF546E7A),
  onSecondary: Colors.black,
  error: Color(0xFFCF6679),
  onError: Colors.black,
  surface: Color(0xFF121212),
  onSurface: Colors.white,
);

//----------------------------------------------------------------
// RUN THE APP
//----------------------------------------------------------------

void main() {
  runApp(const MyApp()); // Launch the application
}

//----------------------------------------------------------------
// APP BODY
//----------------------------------------------------------------
// MyApp is a StatelessWidget that doesn't hold any mutable state
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor to initialize MyApp

  @override
  Widget build(BuildContext context) { // here things when changed can be hot reloaded
    // Build method returns the widget's user interface
    return MaterialApp(
      debugShowCheckedModeBanner: true,              // Show a Debug banner on top-right corner during development
      title: appName,
      theme: ThemeData(colorScheme: lightScheme),
      darkTheme: ThemeData(colorScheme: darkScheme),
      themeMode: ThemeMode.system,                    // Change theme along with system
      home: const MyHomePage(                         // MyHomePage is widget with a state, it changes! containing the app scheleton: Scaffold
        title: appName,
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // in every function that modify one variable visible to the user one need to modify the state
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: AppDrawerWidget(),
      bottomNavigationBar: NavBarWidget(),
      body: WidgetTree(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
