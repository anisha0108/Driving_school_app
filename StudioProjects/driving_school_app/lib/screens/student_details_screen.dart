import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_student_screen.dart';
import 'progress_tracker_screen.dart';
import 'add_payment_screen.dart';
import 'payment_history_screen.dart';
import 'attendance_screen.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> student;
  final String documentId;

  const StudentDetailsScreen({
    super.key,
    required this.student,
    required this.documentId,
  });

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              student['name'] ?? "",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            buildInfoCard(
              icon: Icons.phone,
              title: "Phone Number",
              value: student['phone'].toString(),
              color: Colors.green,
            ),

            buildInfoCard(
              icon: Icons.cake,
              title: "Age",
              value: student['age'].toString(),
              color: Colors.orange,
            ),

            buildInfoCard(
              icon: Icons.home,
              title: "Address",
              value: student['address'].toString(),
              color: Colors.blue,
            ),

            buildInfoCard(
              icon: Icons.directions_car,
              title: "Vehicle",
              value: student['vehicle'].toString(),
              color: Colors.red,
            ),

            buildInfoCard(
              icon: Icons.calendar_today,
              title: "Joining Date",
              value: student['joiningDate'].toString(),
              color: Colors.purple,
            ),

            buildInfoCard(
              icon: Icons.person_outline,
              title: "Trainer",
              value: student['trainer'].toString(),
              color: Colors.teal,
            ),

            buildInfoCard(
              icon: Icons.currency_rupee,
              title: "Total Fees",
              value: "₹${student['totalFees']}",
              color: Colors.indigo,
            ),

            buildInfoCard(
              icon: Icons.payments,
              title: "Paid Fees",
              value: "₹${student['paidFees']}",
              color: Colors.green,
            ),

            buildInfoCard(
              icon: Icons.money_off,
              title: "Pending Fees",
              value: "₹${student['pendingFees']}",
              color: Colors.red,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStudentScreen(
                        documentId: documentId,
                        student: student,
                      ),
                    ),
                  );
                }, label: const Text("Edit Student"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {

                  bool? delete = await showDialog(

                    context: context,

                    builder: (_) => AlertDialog(

                      title: const Text("Delete Student"),

                      content: const Text(
                          "Are you sure you want to delete this student?"),

                      actions: [

                        TextButton(

                          onPressed: () {

                            Navigator.pop(context, false);

                          },

                          child: const Text("Cancel"),

                        ),

                        ElevatedButton(

                          onPressed: () {

                            Navigator.pop(context, true);

                          },

                          child: const Text("Delete"),

                        ),

                      ],

                    ),

                  );

                  if (delete == true) {

                    await FirebaseFirestore.instance
                        .collection("students")
                        .doc(documentId)
                        .delete();

                    Navigator.pop(context);

                  }

                }, label: const Text("Delete Student"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.timeline),
                label: const Text("Driving Progress"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgressTrackerScreen(
                        documentId: documentId,
                        student: student,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text("Mark as Completed"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("students")
                      .doc(documentId)
                      .update({
                    "completed": true,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Student marked as completed"),
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payments),
                label: const Text("Add Payment"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddPaymentScreen(
                        documentId: documentId,
                        student: student,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text("Payment History"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentHistoryScreen(
                        documentId: documentId,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text("Attendance"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AttendanceScreen(
                        documentId: documentId,
                        student: student,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}