import 'package:flutter/material.dart';
import 'permissions_model.dart';

class PatientPermissionsScreen extends StatefulWidget {
  const PatientPermissionsScreen({super.key});

  @override
  _PatientPermissionsScreenState createState() =>
      _PatientPermissionsScreenState();
}

class _PatientPermissionsScreenState extends State<PatientPermissionsScreen> {
  late PermissionsModel _permissionsModel;
  late Map<String, bool> accessPermissions;

  @override
  void initState() {
    super.initState();
    _permissionsModel = PermissionsModel();
    // Get permissions for current user
    accessPermissions = _permissionsModel.currentUserPermissions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Patient Permissions'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 50, color: Colors.blue[700]),
            const SizedBox(height: 12),
            Text(
              'Manage What Hospitals Can Access 🛡️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Toggle access to specific medical info that hospitals can see.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue[700]),
            ),
            const SizedBox(height: 20),
            ...accessPermissions.entries.map((entry) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                        // Update the shared permissions model
                        _permissionsModel.updatePermission(entry.key, value);
                      });
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}