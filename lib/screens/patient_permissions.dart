import 'package:flutter/material.dart';

class PatientPermissionsScreen extends StatefulWidget {
  @override
  _PatientPermissionsScreenState createState() =>
      _PatientPermissionsScreenState();
}

class _PatientPermissionsScreenState extends State<PatientPermissionsScreen> {
  Map<String, bool> accessPermissions = {
    'Vitals': true,
    'Medications': false,
    'Lab Results': true,
    'Allergies': false,
    'Appointments': true,
    'Billing Info': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Patient Permissions'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 50, color: Colors.blue[700]),
            SizedBox(height: 12),
            Text(
              'Manage What Hospitals Can Access 🛡️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Toggle access to specific medical info that hospitals can see.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue[700]),
            ),
            SizedBox(height: 20),
            ...accessPermissions.entries.map((entry) {
              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(
                    entry.value ? Icons.check_circle : Icons.cancel,
                    color: entry.value ? Colors.green : Colors.redAccent,
                  ),
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                  trailing: Switch(
                    value: entry.value,
                    activeColor: Colors.blue[600],
                    onChanged: (bool value) {
                      setState(() {
                        accessPermissions[entry.key] = value;
                      });
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
