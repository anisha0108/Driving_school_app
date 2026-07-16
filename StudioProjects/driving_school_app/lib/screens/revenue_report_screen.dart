import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class RevenueReportScreen extends StatelessWidget {
  const RevenueReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue Report"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("students")
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          double collectedRevenue = 0;
          double pendingRevenue = 0;
          double totalRevenue = 0;

          for (var doc in snapshot.data!.docs) {

            final student =
            doc.data() as Map<String, dynamic>;

            collectedRevenue +=
                (student["paidFees"] ?? 0).toDouble();

            pendingRevenue +=
                (student["pendingFees"] ?? 0).toDouble();

          }
          totalRevenue =
              collectedRevenue + pendingRevenue;
          return ListView(
            padding: const EdgeInsets.all(16),

            children: [

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.green,
                  ),
                  title: const Text("Total Revenue"),
                  trailing: Text(
                    "₹${totalRevenue.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.payments,
                    color: Colors.blue,
                  ),
                  title: const Text("Collected Revenue"),
                  trailing: Text(
                    "₹${collectedRevenue.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.money_off,
                    color: Colors.red,
                  ),
                  title: const Text("Pending Revenue"),
                  trailing: Text(
                    "₹${pendingRevenue.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

            ],
          );

        },
      ),
    );
  }
}
