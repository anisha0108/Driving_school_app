import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Report"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("students")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Data Found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          DateTime now = DateTime.now();

          int currentMonth = now.month;
          int currentYear = now.year;

          int totalStudents = 0;
          int completedStudents = 0;

          double totalRevenue = 0;
          double pendingFees = 0;

          for (var doc in snapshot.data!.docs) {
            final student = doc.data() as Map<String, dynamic>;

            if (student["createdAt"] == null) continue;

            Timestamp timestamp = student["createdAt"];

            DateTime joiningDate = timestamp.toDate();

            if (joiningDate.month == currentMonth &&
                joiningDate.year == currentYear) {
              totalStudents++;

              if (student["completed"] == true) {
                completedStudents++;
              }

              totalRevenue +=
                  (student["paidFees"] ?? 0).toDouble();

              pendingFees +=
                  (student["pendingFees"] ?? 0).toDouble();
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ReportCard(
                title: "Students Joined",
                value: totalStudents.toString(),
                icon: Icons.people,
                color: Colors.blue,
              ),

              ReportCard(
                title: "Completed Students",
                value: completedStudents.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),

              ReportCard(
                title: "Revenue",
                value: "₹${totalRevenue.toStringAsFixed(0)}",
                icon: Icons.currency_rupee,
                color: Colors.orange,
              ),

              ReportCard(
                title: "Pending Fees",
                value: "₹${pendingFees.toStringAsFixed(0)}",
                icon: Icons.money_off,
                color: Colors.red,
              ),
            ],
          );
        },
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ReportCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}