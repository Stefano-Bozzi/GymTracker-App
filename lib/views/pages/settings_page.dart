//________________________________________________________________
// SETTINGS: page that contains all app settings
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:gym_tracker/data/notifiers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar_community/isar.dart';
import 'package:gym_tracker/main.dart';
import 'package:gym_tracker/data/workout_isar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Show an error message
  void _showError(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Attention", style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ---- EXPORT ISAR DATA TO SPECIFIED PATH ----

  /// Save current database and export it in a specified fodler to transfer data between devices
  Future<void> _backupIsarDB(BuildContext context) async {
    try {
      // get DB directory
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File(
        '${dir.path}/default.isar',
      );
      // if not found, show error
      if (!await dbFile.exists()) {
        if (context.mounted){
            _showError(
              "Database not found.",
              context,
            );
          }
        return;
      }

      // ask user what folder use to save the current DB
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select a folder to save your backup',
      );

      if (selectedDirectory == null) {
        // user canceled or undo
        return;
      }

      // create name
      String date = DateTime.now().toIso8601String().split('T').first;
      String defaultName = 'gym_tracker_backup_$date';
      TextEditingController savingNameController = TextEditingController(text: defaultName);
      
      // show dialog to insert name
      if (!context.mounted) return;
      String? finalFileName = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Backup-file Name'),
          content: TextField(
            controller: savingNameController,
            decoration: const InputDecoration(
              labelText: 'File name',
              suffixText: '.isar', // fix extension
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Confirm inserted text
                Navigator.pop(ctx, savingNameController.text); 
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );

      // if user canceled interrupt
      if (finalFileName == null || finalFileName.trim().isEmpty) {
        return;
      }

      String destinationPath = '$selectedDirectory/${finalFileName.trim()}.isar';
      
      // Copy isar file
      // isar has a secure copy when db is used
      await isar.copyToFile(destinationPath);
      // or copy the file directly, if prevoius method does not work:
      //await dbFile.copy(destinationPath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Backup successfully saved in:\n$destinationPath"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) _showError("Error during backup: $e", context);
    }
  }

  // ---- IMPORT ISAR DATA FROM SPECIFIED PATH ----

  /// Import data from file
  Future<void> _restoreIsarDB(BuildContext context) async {
    // ask user to select file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['isar'],
    );

    if (result == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Exited"),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    File newFile = File(result.files.single.path!);

    // User warning
    if (!context.mounted) return;
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "WARNING: ALL DATA WILL BE DELETED",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          """
Importing a new database will OVERWRITE all your current data. 
It is strongly recommended that you back up your existing database first.
         
Are you sure you want to proceed with the import?
          """,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Proceed and overwrite",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) {
      // Canceled or undo
      return;
    }

    // Restore execution
    try {
      final dir = await getApplicationDocumentsDirectory();
      final currentDbFile = File(
        '${dir.path}/default.isar',
      );

      // close active db before deleting it
      await isar.close();

      if (await currentDbFile.exists()) {
        await currentDbFile.delete(); // Remove db
      }

      // insert selected file
      await newFile.copy(currentDbFile.path);

      if (context.mounted) {
        // initializing database
        final dirNewDb = await getApplicationDocumentsDirectory();
        isar = await Isar.open(
          [IsarWorkoutSchema, IsarTemplateWorkoutSchema],
          directory: dirNewDb.path,
        );
        selectedPageNotifier.value = 0;
        
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully overwritten Database!"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted){
        _showError("Error occurred during import: $e", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // THEME SELECTION --------------------------------------------
          const Text(
            "Aspect",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Choose theme mode"),
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

          const SizedBox(height: 8),
          const Text("Choose between kg or lb"),
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
          const Text(
            "Backup & Export",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text("Backup Database (.isar)"),
            subtitle: const Text("Save an exact copy of your data"),
            onTap: () => _backupIsarDB(context),
          ),

          // -- UPLOAD (RESTORE) --
          const SizedBox(height: 16),
          const Text(
            "Restore & Import",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text("Restore Database (.isar)"),
            subtitle: const Text("Overwrite current data with a backup"),
            onTap: () => _restoreIsarDB(context),
          ),
        ],
      ),
    );
  }
}
