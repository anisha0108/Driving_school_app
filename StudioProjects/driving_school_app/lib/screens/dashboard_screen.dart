import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_student_screen.dart';
import 'edit_instructor_screen.dart';
import 'student_list_screen.dart';
import 'payments_screen.dart';
import 'instructor_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driving School Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Admin 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("students")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final students = snapshot.data!.docs;

                int totalStudents = students.length;
                int totalPaid = 0;
                int totalPending = 0;
                int completedStudents = 0;

                for (var doc in students) {
                  final data = doc.data() as Map<String, dynamic>;

                  totalPaid +=
                      int.tryParse(data["paidFees"].toString()) ?? 0;

                  totalPending +=
                      int.tryParse(data["pendingFees"].toString()) ?? 0;

                  if ((data["pendingFees"] ?? 1) == 0) {
                    completedStudents++;
                  }
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9,
                  children: [

                    DashboardCard(
                      title: "Students",
                      value: totalStudents.toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),

                    DashboardCard(
                      title: "Collected",
                      value: "₹$totalPaid",
                      icon: Icons.payments,
                      color: Colors.green,
                    ),

                    DashboardCard(
                      title: "Pending",
                      value: "₹$totalPending",
                      icon: Icons.money_off,
                      color: Colors.orange,
                    ),

                    DashboardCard(
                      title: "Completed",
                      value: completedStudents.toString(),
                      icon: Icons.check_circle,
                      color: Colors.purple,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: const [

                  MenuButton(
                    title: "Add Student",
                    icon: Icons.person_add,
                    screen: AddStudentScreen(),
                  ),

                  MenuButton(
                    title: "Student List",
                    icon: Icons.list_alt,
                    screen: StudentListScreen(),
                  ),

                  MenuButton(
                    title: "Instructor Management",
                    icon: Icons.school,
                    screen: InstructorListScreen(),
                  ),

                  MenuButton(
                    title: "Payments",
                    icon: Icons.account_balance_wallet,
                    screen: PaymentsScreen(),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget screen;

  const MenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );
        },
      ),
    );
  }
}