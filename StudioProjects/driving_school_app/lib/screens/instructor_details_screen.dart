import 'package:flutter/material.dart';
import 'edit_instructor_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class InstructorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> instructor;
  final String documentId;

  const InstructorDetailsScreen({
    super.key,
    required this.instructor,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructor Details"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              instructor["name"],
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text("Phone : ${instructor["phone"]}"),
            Text("Experience : ${instructor["experience"]}"),
            Text("License : ${instructor["licenseNo"]}"),
            Text("Address : ${instructor["address"]}"),
            Text("Vehicle : ${instructor["vehicle"]}"),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Instructor"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditInstructorScreen(
                        documentId: documentId,
                        instructor: instructor,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.delete),
                label: const Text("Delete Instructor"),
                onPressed: () async {

                  bool? result = await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Instructor"),
                      content: const Text(
                        "Are you sure you want to delete this instructor?",
                      ),
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

                  if (result == true) {

                    await FirebaseFirestore.instance
                        .collection("instructors")
                        .doc(documentId)
                        .delete();

                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Assigned Students",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("students")
                  .where("trainerId", isEqualTo: documentId)
                  .snapshots(),

              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    "No students assigned",
                    style: TextStyle(fontSize: 16),
                  );
                }

                final students = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students.length,

                  itemBuilder: (context, index) {

                    final student =
                    students[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),

                      child: ListTile(

                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),

                        title: Text(student["name"] ?? ""),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Phone : ${student["phone"]}"),

                            Text("Vehicle : ${student["vehicle"]}"),

                          ],
                        ),

                      ),
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}