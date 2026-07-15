import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payments"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: const Padding(
                padding: EdgeInsets.all(20),

                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Rahul Patil",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    PaymentRow(
                      title: "Total Fee",
                      amount: "₹5000",
                      color: Colors.blue,
                    ),

                    Divider(),

                    PaymentRow(
                      title: "Paid",
                      amount: "₹3000",
                      color: Colors.green,
                    ),

                    Divider(),

                    PaymentRow(
                      title: "Pending",
                      amount: "₹2000",
                      color: Colors.red,
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Payment History",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: const [

                  PaymentHistoryCard(
                    date: "10 July 2026",
                    amount: "₹1000",
                  ),

                  PaymentHistoryCard(
                    date: "15 July 2026",
                    amount: "₹2000",
                  ),

                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: () {},

                icon: const Icon(Icons.add),

                label: const Text(
                  "ADD PAYMENT",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class PaymentRow extends StatelessWidget {

  final String title;
  final String amount;
  final Color color;

  const PaymentRow({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(
        Icons.currency_rupee,
        color: color,
      ),

      title: Text(title),

      trailing: Text(
        amount,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class PaymentHistoryCard extends StatelessWidget {

  final String date;
  final String amount;

  const PaymentHistoryCard({
    super.key,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: const Icon(
          Icons.receipt_long,
          color: Colors.blue,
        ),

        title: Text(date),

        trailing: Text(
          amount,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}