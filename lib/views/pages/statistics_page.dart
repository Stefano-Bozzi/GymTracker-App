//________________________________________________________________
// STATISTICS: page that contains app statistics and charts
//________________________________________________________________

import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:gym_tracker/main.dart';
import 'package:gym_tracker/data/workout_isar.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _timeWindow = "M";

  /// Generate data for graph from Isar data
  Future<List<BarChartGroupData>> _getChartData() async {
    final now = DateTime.now();
    DateTime? startDate;
    int numBars = 0;
    int daysPerBar = 1;

    // 1. Config how many bar there are and how many days per bar
    switch (_timeWindow) {
      case "M": // 1 Month - 4 weeks - 7 days
        startDate = DateTime(now.year, now.month - 1, now.day);
        numBars = 4;
        daysPerBar = 7;
        break;
      case "TM": // 3 Months - 30 days
        startDate = DateTime(now.year, now.month - 3, now.day);
        numBars = 3;
        daysPerBar = 30;
        break;
      case "SM": // 6 Months - 30 days
        startDate = DateTime(now.year, now.month - 6, now.day);
        numBars = 6;
        daysPerBar = 30;
        break;
      case "Y": // 1 Year - 12 weeks - 30 days
        startDate = DateTime(now.year - 1, now.month, now.day);
        numBars = 12;
        daysPerBar = 30;
        break;
      case "T": // Total - 5 years - 365 days
      default:
        startDate = null; 
        numBars = 5;
        daysPerBar = 365;
    }

    // 2. Load sessions from db
    List<IsarWorkout> workouts;
    if (startDate == null) {
      workouts = await isar.isarWorkouts.where().findAll();
    } else {
      workouts = await isar.isarWorkouts.filter().dateGreaterThan(startDate).findAll();
    }

    // 3. Prepare buckerts
    List<double> buckets = List.filled(numBars, 0);

    for (var w in workouts) {

      // Calculate how many days ago was registered the session
      int daysAgo = now.difference(w.date).inDays;
      
      // Calculate in which column need to be
      int barIndex = (numBars - 1) - (daysAgo ~/ daysPerBar);

      // If counted, add 1 to bar
      if (barIndex >= 0 && barIndex < numBars) {
        buckets[barIndex]++;
      }
    }

    // 5. Convert bucket into FL type
    List<BarChartGroupData> chartData = [];
    for (int i = 0; i < buckets.length; i++) {
      chartData.add(_makeBar(i+1, buckets[i]));
    }
    
    return chartData;
  }

  /// Helper Function to create clean bars
  BarChartGroupData _makeBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blueAccent,
          width: 16, 
          borderRadius: BorderRadius.circular(4), 
        ),
      ],
    );
  }

  /// Creates labels for x axis
  Widget _bottomTitles(double value, TitleMeta meta) {
    int val = value.toInt();


    return SideTitleWidget(
      meta: meta,
      space: 8.0,
      child: Text(
        "$val",
        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

// --- UI PAGE ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
          const Text(
            "Workout Consistency",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Time Window",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Filter your statistics by period"),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: "T", label: Text("Total")),
                ButtonSegment(value: "Y", label: Text("1Y")),
                ButtonSegment(value: "SM", label: Text("6M")),
                ButtonSegment(value: "TM", label: Text("3M")),
                ButtonSegment(value: "M", label: Text("1M")),
              ],
              selected: {_timeWindow},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _timeWindow = newSelection.first;
                });
              },
            ),
          ),

          const SizedBox(height: 32),

          // -- Graph box --

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Workouts per period",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Wrap the graph in a FutureBuilder
                  SizedBox(
                    height: 200,
                    child: FutureBuilder<List<BarChartGroupData>>(
                      future: _getChartData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No data for this period"));
                        }

                        // If there are data
                        return BarChart(
                          BarChartData(
                            barGroups: snapshot.data!,
                            borderData: FlBorderData(show: false),

                        titlesData: FlTitlesData(
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              
                              // -- Y axis title --
                              leftTitles: AxisTitles(
                                axisNameWidget: const Text("Number of workouts", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                axisNameSize: 20,
                                sideTitles: SideTitles(
                                  showTitles: true, 
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 1 != 0) return const SizedBox.shrink(); // hide not integer numbers
                                    return SideTitleWidget(
                                      meta: meta,
                                      child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    );
                                  },
                                ),
                              ),
                              
                              // -- X axis title --
                              bottomTitles: AxisTitles(
                                axisNameWidget: Text(
                                  _timeWindow == "M" ? "Past weeks" : 
                                  _timeWindow == "T" ? "Past years" : "Past months", 
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                ),
                                axisNameSize: 20,
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: _bottomTitles,
                                  reservedSize: 30,
                                ),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              checkToShowHorizontalLine: (value) => value % 1 == 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}