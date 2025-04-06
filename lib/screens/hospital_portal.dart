import 'package:flutter/material.dart';
import 'hospital_permissions.dart'; // Import the permissions screen
import 'hospital_billing_history.dart'; // Import the new billing history screen

class HospitalPortal extends StatelessWidget {
  const HospitalPortal({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Hospital Portal'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Welcome, Hospital Admin! 👨‍⚕️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage apps, control permissions, and view system activity logs.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue[700]),
            ),
            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardButton(context, "Patient Stats", Icons.bar_chart),
                _buildDashboardButton(context, "App", Icons.apps),
                _buildDashboardButton(context, "Billing History", Icons.receipt_long),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDashboardButton(BuildContext context, String title, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey[300],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      ),
      onPressed: () {
        if (title == "Patient Stats") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HospitalPermissionsScreen(),
            ),
          );
        } else if (title == "Billing History") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BillingHistoryScreen(),
            ),
          );
        }
        // You can add similar conditions for other buttons later
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue[700], size: 30),
          const SizedBox(height: 10),
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