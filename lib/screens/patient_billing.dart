import 'package:flutter/material.dart';
import 'package:medimesh/screens/insurance_card_scanner.dart';
import 'package:medimesh/screens/credit_card_scanner.dart';

class PatientBillingScreen extends StatefulWidget {
  @override
  _PatientBillingScreenState createState() => _PatientBillingScreenState();
}

class _PatientBillingScreenState extends State<PatientBillingScreen> {
  String groupNumber = '';
  String memberId = '';
  String planCoverage = '';
  String cardHolderName = '';
  String expiryDate = '';
  final TextEditingController creditCardController = TextEditingController();

  void updateInsuranceInfo(String scannedText) {
    setState(() {
      groupNumber = _extractMatch(scannedText, r'Group\s*#[:\s]*([A-Za-z0-9\-]+)');
      memberId = _extractMatch(scannedText, r'Member\s*ID[:\s]*([A-Za-z0-9\-]+)');
      planCoverage = _extractMatch(scannedText, r'Plan\s*Coverage[:\s]*(.+)');
    });
  }

  void updateCreditCardInfo(Map<String, String> data) {
    setState(() {
      creditCardController.text = data['cardNumber'] ?? '';
      cardHolderName = data['cardHolderName'] ?? '';
      expiryDate = data['expiryDate'] ?? '';
    });
  }

  String _extractMatch(String text, String pattern) {
    final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
    return match != null ? match.group(1)!.trim() : 'Not found';
  }

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
              'Scan your insurance and credit cards for quick access.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue[700]),
            ),
            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () async {
                final scannedText = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InsuranceCardScanner()),
                );
                if (scannedText != null && scannedText is String) {
                  updateInsuranceInfo(scannedText);
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Scan Insurance Card'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            SizedBox(height: 20),

            if (groupNumber.isNotEmpty || memberId.isNotEmpty || planCoverage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Group Number", groupNumber),
                    _infoRow("Member ID", memberId),
                    _infoRow("Plan Coverage", planCoverage),
                  ],
                ),
              ),

            SizedBox(height: 30),

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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                final cardData = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreditCardScanner()),
                );
                if (cardData != null && cardData is Map<String, String>) {
                  updateCreditCardInfo(cardData);
                }
              },
              icon: Icon(Icons.credit_card),
              label: Text("Scan Credit Card"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            if (cardHolderName.isNotEmpty || expiryDate.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.purpleAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Cardholder Name", cardHolderName),
                    _infoRow("Expiry Date", expiryDate),
                  ],
                ),
              ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
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

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        "$title: $value",
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
