//________________________________________________________________
// MAIN: Entry point and global app settings
//________________________________________________________________

//----------------------------------------------------------------
// IMPORT LIBRARIES
//----------------------------------------------------------------

import 'package:flutter/material.dart';                   // Imports the Flutter Material library for UI widgets and themes.
import 'package:gym_tracker/views/widget_tree.dart';      // Imports the primary Widget that defines the application structure (Scaffold, Navigation).
import 'package:gym_tracker/constants/constants.dart';    // Imports global constants like the app name and theme definitions.
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gym_tracker/data/workout_isar.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// global var to sign in to database into app
late Isar isar;

//----------------------------------------------------------------
// RUN THE APP
//----------------------------------------------------------------

void main() async{

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Database initialization
  // Screen show splash page
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [IsarWorkoutSchema, IsarTemplateWorkoutSchema],
    directory: dir.path,
  );

  runApp(const MyApp()); // Launches the Flutter application.

  // Close Slash page when finished drawing first app page
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
}

//----------------------------------------------------------------
// APP BODY
//----------------------------------------------------------------

class MyApp extends StatelessWidget {
  // MyApp is the application's root widget. It is 'Stateless' because 
  // its configuration (the MaterialApp) does not change during the app's runtime.
  // Dynamic state (e.g., page switching) is managed by child widgets or Notifiers.
  const MyApp({super.key}); 
  // Constructor for MyApp.

  @override
  Widget build(BuildContext context) { 
    // The build method describes the widget's user interface.
    // Any changes here can be quickly updated via Hot Reload.
    return MaterialApp(
      debugShowCheckedModeBanner: true,               // Shows the 'Debug' banner in the top-right corner during development.
      title: appName,                                 // Application title (visible in the operating system's task switcher).
      theme: ThemeData(colorScheme: lightScheme),     
      darkTheme: ThemeData(colorScheme: darkScheme),  
      themeMode: ThemeMode.system,                    // Chooses the theme (light/dark) based on the operating system settings.
      home: const WidgetTree(),                       // The main widget that defines the Scaffold, navigation, 
                                                      // and the overall layout of the user interface.
    );
  }
}