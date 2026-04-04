//________________________________________________________________
// DRAWER: widget for custom Drawer
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:gym_tracker/views/pages/licenses_page.dart';
import 'package:gym_tracker/views/pages/settings_page.dart';
import 'package:gym_tracker/constants/constants.dart';
import 'package:gym_tracker/views/pages/statistics_page.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
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
                  Navigator.pop(context); 
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>StatisticsPage(),),
                  ); 
                },
              ),
              
              // Settings
              ListTile(
                leading: const Icon(Icons.settings_rounded),
                title: const Text('Settings'),
                onTap: () {
                  // here the logic
                  Navigator.pop(context); 
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>SettingsPage(),),
                  );
                },
              ),
              
              // Licenses
              ListTile(
                leading: const Icon(Icons.attribution_rounded),
                title: const Text('Licenses'),
                onTap: () {
                  Navigator.pop(context); // close the drawer
                  // go to licenses page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LicensesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
            ),
          Text("$appName - $appVersion"),
          SizedBox(height: 25,)
        ]
      )  
    );
  }
}