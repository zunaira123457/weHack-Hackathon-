import 'package:flutter/material.dart';

class PatientBillingScreen extends StatefulWidget {
  @override
  _PatientBillingScreenState createState() => _PatientBillingScreenState();
}

class _PatientBillingScreenState extends State<PatientBillingScreen> {
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController creditCardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Billing & Insurance'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, size: 50, color: Colors.blue[700]),
            SizedBox(height: 12),
            Text(
              'Enter Your Billing Information',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'You can either scan or manually enter your insurance and credit card details.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue[700]),
            ),
            SizedBox(height: 30),

            // Insurance Card Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Insurance Card",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800]),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: insuranceController,
              decoration: InputDecoration(
                hintText: 'Enter Insurance ID',
                fillColor: Colors.white,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Simulated scanner
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('📷 Scanner not available in this demo.')),
                );
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Scan Insurance Card'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            SizedBox(height: 30),

            // Credit Card Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Credit Card",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800]),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: creditCardController,
              decoration: InputDecoration(
                hintText: 'Enter Credit Card Number',
                fillColor: Colors.white,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate saving billing info
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Billing info saved!')),
                );
              },
              child: Text('Save Billing Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
