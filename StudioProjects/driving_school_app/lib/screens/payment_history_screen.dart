import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final String documentId;

  const PaymentHistoryScreen({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment History"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("students")
            .doc(documentId)
            .collection("payments")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final payments = snapshot.data!.docs;

          if (payments.isEmpty) {
            return const Center(
              child: Text("No Payments Yet"),
            );
          }

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment =
              payments[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(
                    Icons.payments,
                    color: Colors.green,
                  ),
                  title: Text("₹${payment["amount"]}"),
                  subtitle: Text(payment["receiptNo"]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}