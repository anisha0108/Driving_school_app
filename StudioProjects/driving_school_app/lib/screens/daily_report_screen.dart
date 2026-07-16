import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyReportScreen extends StatelessWidget {
  const DailyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Daily Report"),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("payments")
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          double total = 0;

          for (var doc in snapshot.data!.docs) {

            final payment =
            doc.data() as Map<String, dynamic>;

            total +=
                (payment["amount"] ?? 0).toDouble();

          }

          return Center(

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const Text(
                  "Today's Collection",
                  style: TextStyle(fontSize: 24),
                ),

                Text(
                  "₹${total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}