import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInstructorScreen extends StatefulWidget {
  const AddInstructorScreen({super.key});

  @override
  State<AddInstructorScreen> createState() =>
      _AddInstructorScreenState();
}

class _AddInstructorScreenState
    extends State<AddInstructorScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final experienceController = TextEditingController();
  final licenseController = TextEditingController();
  final addressController = TextEditingController();
  final vehicleController = TextEditingController();

  Future<void> saveInstructor() async {

    await FirebaseFirestore.instance
        .collection("instructors")
        .add({

      "name": nameController.text.trim(),

      "phone": phoneController.text.trim(),

      "experience": experienceController.text.trim(),

      "licenseNo": licenseController.text.trim(),

      "address": addressController.text.trim(),

      "vehicle": vehicleController.text.trim(),

      "createdAt": Timestamp.now(),

    });

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text("Instructor Added Successfully"),

      ),

    );

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Add Instructor"),

        backgroundColor: Colors.blue,

        foregroundColor: Colors.white,

      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Instructor Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: experienceController,
                decoration: const InputDecoration(
                  labelText: "Experience",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: licenseController,
                decoration: const InputDecoration(
                  labelText: "License Number",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: vehicleController,
                decoration: const InputDecoration(
                  labelText: "Vehicle",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed: saveInstructor,

                  child: const Text(

                    "Save Instructor",

                    style: TextStyle(fontSize: 18),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}