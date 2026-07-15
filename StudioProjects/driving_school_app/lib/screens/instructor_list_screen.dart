import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_instructor_screen.dart';
import 'instructor_details_screen.dart';

class InstructorListScreen extends StatelessWidget {
  const InstructorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructor List"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("instructors")
            .orderBy("createdAt", descending: true)
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
                "No Instructors Found",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          final instructors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: instructors.length,

            itemBuilder: (context, index) {

              final instructor =
              instructors[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
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
                    instructor["name"] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Phone: ${instructor["phone"]}"),

                      Text("Vehicle: ${instructor["vehicle"]}"),

                      Text("Experience: ${instructor["experience"]}"),

                    ],
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InstructorDetailsScreen(
                          instructor: instructor,
                          documentId: instructors[index].id,
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddInstructorScreen(),
            ),
          );
        },
      ),
    );
  }
}