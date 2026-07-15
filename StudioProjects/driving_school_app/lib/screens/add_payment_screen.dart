import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPaymentScreen extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> student;

  const AddPaymentScreen({
    super.key,
    required this.documentId,
    required this.student,
  });

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {

  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    int totalFees = int.tryParse(widget.student["totalFees"].toString()) ?? 0;
    int paidFees = int.tryParse(widget.student["paidFees"].toString()) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Payment"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Text(
              widget.student["name"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text("Total Fees : ₹$totalFees"),

            Text("Paid Fees : ₹$paidFees"),

            Text("Pending Fees : ₹${totalFees - paidFees}"),

            const SizedBox(height: 20),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Payment Amount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () async {

                  int payment = int.tryParse(amountController.text) ?? 0;

                  int newPaid = paidFees + payment;
                  int pending = totalFees - newPaid;

                  String receiptNo =
                      "RCPT${DateTime.now().millisecondsSinceEpoch}";

                  await FirebaseFirestore.instance
                      .collection("students")
                      .doc(widget.documentId)
                      .update({
                    "paidFees": newPaid,
                    "pendingFees": pending,
                  });

                  await FirebaseFirestore.instance
                      .collection("students")
                      .doc(widget.documentId)
                      .collection("payments")
                      .add({
                    "amount": payment,
                    "date": Timestamp.now(),
                    "receiptNo": receiptNo,
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                },

                child: const Text("Save Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}