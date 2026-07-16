import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressTrackerScreen extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> student;

  const ProgressTrackerScreen({
    super.key,
    required this.documentId,
    required this.student,
  });

  @override
  State<ProgressTrackerScreen> createState() =>
      _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {

  List<String> lessons = [
    "Vehicle Introduction",
    "Steering Control",
    "Clutch Practice",
    "Gear Shifting",
    "Reverse Driving",
    "Parking",
    "Traffic Driving",
    "Highway Driving",
    "Night Driving",
    "Final Test",
  ];

  List<bool> completed = List.filled(10, false);

  @override
  void initState() {
    super.initState();

    final progress =
    widget.student["progress"] as Map<String, dynamic>?;

    if (progress != null) {
      for (int i = 0; i < lessons.length; i++) {
        completed[i] = progress["day${i + 1}"] ?? false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int completedCount =
        completed.where((item) => item).length;

    double progress =
        completedCount / lessons.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driving Progress"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
        body: Column(
    children: [

    Padding(
    padding: const EdgeInsets.all(16),

    child: Column(
    children: [

    Text(
    "$completedCount / ${lessons.length} Lessons Completed",
    style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 10),

    LinearProgressIndicator(
    value: progress,
    minHeight: 10,
    borderRadius: BorderRadius.circular(10),
    ),

    const SizedBox(height: 10),

    Text(
    "${(progress * 100).toStringAsFixed(0)}%",
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),

    Expanded(
    child: ListView.builder(
    itemCount: lessons.length,
    itemBuilder: (context, index) {

    return Card(
    margin: const EdgeInsets.all(8),

    child: CheckboxListTile(
    title: Text(
    "Day ${index + 1} - ${lessons[index]}",
    ),

    value: completed[index],

      onChanged: (value) async {
        if (value == null) return;

        setState(() {
          completed[index] = value;
        });

        // Check if all lessons are completed
        bool courseCompleted = completed.every((lesson) => lesson);

        await FirebaseFirestore.instance
            .collection("students")
            .doc(widget.documentId)
            .update({
          "progress.day${index + 1}": value,
          "completed": courseCompleted,
        });
      },
    ),
    );
    },
    ),
    ),
    ],
    ),
    );
  }
}