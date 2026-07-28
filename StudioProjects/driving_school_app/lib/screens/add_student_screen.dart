import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final joiningDateController = TextEditingController();
  final trainerController = TextEditingController();
  final feesController = TextEditingController();

  String vehicle = "Car";
  String? selectedTrainer;
  String? selectedTrainerId;


  Future<void> saveStudent() async {
    try {
      await FirebaseFirestore.instance.collection('students').add({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'age': int.tryParse(ageController.text) ?? 0,
        'address': addressController.text.trim(),
        'vehicle': vehicle,
        'joiningDate': joiningDateController.text.trim(),
        "trainer": selectedTrainer,
        "trainerId": selectedTrainerId,
        'totalFees': int.tryParse(feesController.text) ?? 0,
        'paidFees': 0,
        'pendingFees': int.tryParse(feesController.text) ?? 0,
        'createdAt': Timestamp.now(),
        "progress": {
          "day1": false,
          "day2": false,
          "day3": false,
          "day4": false,
          "day5": false,
          "day6": false,
          "day7": false,
          "day8": false,
          "day9": false,
          "day10": false,
          "completed": false,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student Saved Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      nameController.clear();
      phoneController.clear();
      ageController.clear();
      addressController.clear();
      joiningDateController.clear();
      trainerController.clear();
      feesController.clear();

      setState(() {
        vehicle = "Car";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    addressController.dispose();
    joiningDateController.dispose();
    trainerController.dispose();
    feesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("instructors")
                .snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final instructors = snapshot.data!.docs;

              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Instructor",
                  border: OutlineInputBorder(),
                ),

                initialValue: selectedTrainerId,

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

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: vehicle,
              decoration: const InputDecoration(
                labelText: "Vehicle Type",
                prefixIcon: Icon(Icons.directions_car),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Car",
                  child: Text("Car"),
                ),
                DropdownMenuItem(
                  value: "Bike",
                  child: Text("Bike"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  vehicle = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("instructors")
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<String>(

                  initialValue: selectedTrainerId,

                  decoration: const InputDecoration(
                    labelText: "Instructor",
                  ),

                  items: snapshot.data!.docs.map((doc) {

                    final instructor =
                    doc.data() as Map<String, dynamic>;

                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(instructor["name"]),
                    );

                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedTrainerId = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("instructors")
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<String>(
                  initialValue: selectedTrainerId,
                  decoration:
                  const InputDecoration(labelText: "Instructor"),

                  items: snapshot.data!.docs.map((doc) {

                    final data =
                    doc.data() as Map<String, dynamic>;

                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(data["name"]),
                    );

                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedTrainerId = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: feesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total Fees",
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "SAVE STUDENT",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}