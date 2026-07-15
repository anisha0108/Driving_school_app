import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_details_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchText = "";
  String selectedInstructor = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by Name, Phone or Vehicle",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchText = "";
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("instructors")
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final instructors = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  initialValue: selectedInstructor,

                  decoration: const InputDecoration(
                    labelText: "Filter by Instructor",
                    border: OutlineInputBorder(),
                  ),

                  items: [
                    const DropdownMenuItem(
                      value: "All",
                      child: Text("All Instructors"),
                    ),

                    ...instructors.map((doc) {

                      final instructor =
                      doc.data() as Map<String, dynamic>;

                      return DropdownMenuItem(
                        value: instructor["name"],
                        child: Text(instructor["name"]),
                      );

                    })

                  ],

                  onChanged: (value) {

                    setState(() {

                      selectedInstructor = value!;

                    });

                  },
                );

              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Students Found",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final students = snapshot.data!.docs.where((doc) {
                  final student = doc.data() as Map<String, dynamic>;

                  final name =
                  (student["name"] ?? "").toString().toLowerCase();

                  final phone =
                  (student["phone"] ?? "").toString().toLowerCase();

                  final vehicle =
                  (student["vehicle"] ?? "").toString().toLowerCase();

                  bool matchesSearch =
                      name.contains(searchText) ||
                          phone.contains(searchText) ||
                          vehicle.contains(searchText);

                  bool matchesInstructor =
                      selectedInstructor == "All" ||
                          student["trainer"] == selectedInstructor;

                  return matchesSearch && matchesInstructor;
                }).toList();

                if (students.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Matching Student Found",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student =
                    students[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          student["name"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Phone: ${student["phone"] ?? ""}"),
                            Text("Vehicle: ${student["vehicle"] ?? ""}"),
                            Text("Trainer: ${student["trainer"] ?? ""}"),
                          ],
                        ),
                        trailing:
                        const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetailsScreen(
                                student: student,
                                documentId: students[index].id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}