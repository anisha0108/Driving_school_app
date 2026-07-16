import 'package:flutter/material.dart';

import 'daily_report_screen.dart';
import 'monthly_report_screen.dart';
import 'revenue_report_screen.dart';
import 'student_report_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          ReportCard(
            title: "Daily Report",
            icon: Icons.today,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DailyReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            title: "Monthly Report",
            icon: Icons.calendar_month,
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MonthlyReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            title: "Revenue Report",
            icon: Icons.currency_rupee,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RevenueReportScreen(),
                ),
              );
            },
          ),

          ReportCard(
            title: "Student Report",
            icon: Icons.people,
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StudentReportScreen(),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        onTap: onTap,

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
            fontSize: 18,
          ),
        ),

        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}