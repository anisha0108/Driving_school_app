import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStudentScreen extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> student;

  const EditStudentScreen({
    super.key,
    required this.documentId,
    required this.student,
  });

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final vehicleController = TextEditingController();
  final joiningDateController = TextEditingController();
  final totalFeesController = TextEditingController();
  final paidFeesController = TextEditingController();

  String? selectedTrainer;
  String? selectedTrainerId;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.student["name"] ?? "";
    phoneController.text = widget.student["phone"] ?? "";
    ageController.text = widget.student["age"].toString();
    addressController.text = widget.student["address"] ?? "";
    vehicleController.text = widget.student["vehicle"] ?? "";
    joiningDateController.text = widget.student["joiningDate"] ?? "";
    totalFeesController.text = widget.student["totalFees"].toString();
    paidFeesController.text = widget.student["paidFees"].toString();

    selectedTrainer = widget.student["trainer"];
    selectedTrainerId = widget.student["trainerId"];
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    addressController.dispose();
    vehicleController.dispose();
    joiningDateController.dispose();
    totalFeesController.dispose();
    paidFeesController.dispose();
    super.dispose();
  }

  Future<void> updateStudent() async {
    int totalFees = int.tryParse(totalFeesController.text) ?? 0;
    int paidFees = int.tryParse(paidFeesController.text) ?? 0;

    await FirebaseFirestore.instance
        .collection("students")
        .doc(widget.documentId)
        .update({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "age": ageController.text.trim(),
      "address": addressController.text.trim(),
      "vehicle": vehicleController.text.trim(),
      "joiningDate": joiningDateController.text.trim(),
      "trainer": selectedTrainer,
      "trainerId": selectedTrainerId,
      "totalFees": totalFees,
      "paidFees": paidFees,
      "pendingFees": totalFees - paidFees,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Student Updated Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  Widget buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
        title: const Text("Edit Student"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(nameController, "Student Name"),
              buildTextField(
                phoneController,
                "Phone Number",
                keyboardType: TextInputType.phone,
              ),
              buildTextField(
                ageController,
                "Age",
                keyboardType: TextInputType.number,
              ),
              buildTextField(addressController, "Address"),
              buildTextField(vehicleController, "Vehicle"),
              buildTextField(joiningDateController, "Joining Date"),
              buildTextField(
                totalFeesController,
                "Total Fees",
                keyboardType: TextInputType.number,
              ),
              buildTextField(
                paidFeesController,
                "Paid Fees",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 10),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("instructors")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final instructors = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    initialValue: selectedTrainerId,
                    decoration: const InputDecoration(
                      labelText: "Select Instructor",
                      border: OutlineInputBorder(),
                    ),
                    items: instructors.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(data["name"]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTrainerId = value;

                        final trainer = instructors.firstWhere(
                              (doc) => doc.id == value,
                        );

                        selectedTrainer =
                        (trainer.data() as Map<String, dynamic>)["name"];
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: updateStudent,
                  child: const Text(
                    "Update Student",
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