import 'package:flutter/material.dart'; // Import Flutter Material library for UI widgets and themes

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
  onPrimary: Colors.black,
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
      title: 'GainFlow',
      theme: ThemeData(colorScheme: lightScheme),
      darkTheme: ThemeData(colorScheme: darkScheme),
      themeMode: ThemeMode.system,                    // Change theme along with system
      home: const MyHomePage(                         // MyHomePage is widget with a state, it changes! containing the app scheleton: Scaffold
        title: 'GainFlow',
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, //overlap the animation on status bar, but infor are still visible (time, notifications, etc.)
          children: <Widget>[
            // Drawer Title
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Options',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            
            // I want the Drawer to have:
            // Statistics for graphs, 
            // Settings for future fixed theme or reset,
            // Liceses for legal security 

            // Statistics
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded),
              title: const Text('Statistics'),
              onTap: () {
                // here the logic 
              },
            ),
            
            // Settings
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings'),
              onTap: () {
                // here the logic
                // Navigator.pop(context); 
              },
            ),
            
            // Licenses
            ListTile(
              leading: const Icon(Icons.attribution_rounded),
              title: const Text('Licenses'),
              onTap: () {
                // here the logic
                // Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar( //set a list of pages at the bottom. when pressed all the screen change throg the selected page.
        destinations: [
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.fitness_center_rounded), label: 'Workouts'),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
