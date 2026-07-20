import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditInstructorScreen extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> instructor;

  const EditInstructorScreen({
    super.key,
    required this.documentId,
    required this.instructor,
  });

  @override
  State<EditInstructorScreen> createState() =>
      _EditInstructorScreenState();
}

class _EditInstructorScreenState
    extends State<EditInstructorScreen> {

  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController vehicleController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.instructor["name"]);

    phoneController =
        TextEditingController(text: widget.instructor["phone"]);

    vehicleController =
        TextEditingController(text: widget.instructor["vehicle"]);
  }

  Future<void> updateInstructor() async {
    if (!formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection("instructors")
        .doc(widget.documentId)
        .update({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "vehicle": vehicleController.text.trim(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Instructor"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: formKey,

          child: Column(
            children: [

              TextFormField(
                controller: nameController,
                decoration:
                const InputDecoration(labelText: "Name"),
                validator: (v) =>
                v!.isEmpty ? "Enter name" : null,
              ),

              TextFormField(
                controller: phoneController,
                decoration:
                const InputDecoration(labelText: "Phone"),
              ),

              TextFormField(
                controller: vehicleController,
                decoration:
                const InputDecoration(labelText: "Vehicle"),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: updateInstructor,
                child: const Text("Update Instructor"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}