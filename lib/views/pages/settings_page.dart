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

          // THEME SELECTION --------------------------------------------
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

          // UNITY OF MEASUREMENTS --------------------------------------
          const SizedBox(height: 20),

          const Text(
            "Unity of Measurement",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height:8),
          const Text(
            "Choose between kg or lb",
          ),
          const SizedBox(height: 12),

          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: "kg", label: Text("kg")),
              ButtonSegment(value: "lb", label: Text("lb")),
            ],
            selected: {weightNotifier.value},
            onSelectionChanged: (newSelection) {
                weightNotifier.value = newSelection.first;
            },
          ),

          // DATABASE MANAGEMENT ----------------------------------------

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          const Text(
            "Database Management",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // -- SAVE (BACKUP) --
          const Text("Backup & Export", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text("Backup Database (.isar)"),
            subtitle: const Text("Save an exact copy of your data"),
            onTap: () => {},
          ),

          // -- UPLOAD (RESTORE) --
          const SizedBox(height: 16),
          const Text("Restore & Import", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text("Restore Database (.isar)"),
            subtitle: const Text("Overwrite current data with a backup"),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}