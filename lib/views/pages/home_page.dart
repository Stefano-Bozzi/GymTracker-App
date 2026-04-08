//________________________________________________________________
// HOME: page that contains welcome and general info/istructions
//________________________________________________________________

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '''
Private. Local. Offline.
No cloud. No tracking. Just training.

A minimalist fitness app that respects your privacy, runs locally on your device, and doesn’t collect any data.
''',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20, // Font size
            fontWeight: FontWeight.w500, // Font weight
            fontStyle: FontStyle.normal, // Font style
            letterSpacing: 0.5, // Letter spacing
            wordSpacing: 2.0, // Word spacing
            height: 1.5, // Line height
            decoration: TextDecoration.none, // Text decoration
            decorationStyle: TextDecorationStyle.solid, // Decoration style
          ),
        ),
      ),
    );
  }
}
