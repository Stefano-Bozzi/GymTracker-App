//________________________________________________________________
// SETTINGS: page that contains all app settings
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:gym_tracker/data/notifiers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // theme selection via segmented button via ThemeNotifier
          const Text(
            "Aspect",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Choose theme mode",
          ),
          const SizedBox(height: 12),

          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: "A", label: Text("Auto")),
              ButtonSegment(value: "L", label: Text("Light")),
              ButtonSegment(value: "D", label: Text("Dark")),
            ],
            selected: {themeNotifier.value},
            onSelectionChanged: (newSelection) {
                themeNotifier.value = newSelection.first;
            },
          ),
        ],
      ),
    );
  }
}