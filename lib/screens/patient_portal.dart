import 'package:flutter/material.dart';
import 'patient_permissions.dart';
import 'patient_billing.dart';
import 'patient_finance.dart';
import 'speech_to_text.dart';

class PatientPortal extends StatelessWidget {
  final List<String> hospitals = [
    "City Hospital",
    "Wellness Clinic",
    "LabCorp"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Patient Portal'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to your health dashboard! 🩺',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Easily view your stats, manage app permissions, check billing info, and even speak commands!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue[700]),
            ),
            SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardButton(context, "Stats", Icons.bar_chart),
                _buildDashboardButton(context, "App", Icons.mobile_friendly),
                _buildDashboardButton(
                    context, "Permissions", Icons.verified_user),
                _buildDashboardButton(context, "Billing", Icons.payment),
                _buildDashboardButton(context, "Finance", Icons.trending_up),
                _buildDashboardButton(
                    context, "Mic", Icons.mic), // 🎙️ New voice input
              ],
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hospitals You're a Patient In:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              itemCount: hospitals.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.local_hospital, color: Colors.blue[600]),
                  title: Text(
                    hospitals[index],
                    style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
      BuildContext context, String title, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey[300],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      ),
      onPressed: () {
        if (title == "Permissions") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PatientPermissionsScreen()));
        } else if (title == "Billing") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PatientBillingScreen()));
        } else if (title == "Finance") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PatientFinanceScreen()));
        } else if (title == "Mic") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SpeechRecognitionPage()));
        }
        // Add more routes for Stats and App if needed
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue[700], size: 30),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
