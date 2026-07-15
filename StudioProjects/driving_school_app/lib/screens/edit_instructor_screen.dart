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

class _EditInstructorScreenState extends State<EditInstructorScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final experienceController = TextEditingController();
  final licenseController = TextEditingController();
  final addressController = TextEditingController();
  final vehicleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.instructor["name"] ?? "";
    phoneController.text = widget.instructor["phone"] ?? "";
    experienceController.text = widget.instructor["experience"] ?? "";
    licenseController.text = widget.instructor["licenseNo"] ?? "";
    addressController.text = widget.instructor["address"] ?? "";
    vehicleController.text = widget.instructor["vehicle"] ?? "";
  }

  Future<void> updateInstructor() async {
    await FirebaseFirestore.instance
        .collection("instructors")
        .doc(widget.documentId)
        .update({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "experience": experienceController.text.trim(),
      "licenseNo": licenseController.text.trim(),
      "address": addressController.text.trim(),
      "vehicle": vehicleController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Instructor Updated"),
      ),
    );

    Navigator.pop(context);
  }

  Widget buildField(
      TextEditingController controller,
      String label,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Instructor"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            buildField(nameController, "Instructor Name"),
            buildField(phoneController, "Phone"),
            buildField(experienceController, "Experience"),
            buildField(licenseController, "License Number"),
            buildField(addressController, "Address"),
            buildField(vehicleController, "Vehicle"),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateInstructor,
                child: const Text("Update Instructor"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}