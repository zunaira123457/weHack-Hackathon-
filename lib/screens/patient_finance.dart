import 'package:flutter/material.dart';

class PatientFinanceScreen extends StatelessWidget {
  final List<String> hospitals = [
    "City Hospital",
    "Wellness Clinic",
    "LabCorp",
  ];

  final List<Map<String, dynamic>> procedures = [
    {
      'name': 'Blood Test',
      'prices': {
        'City Hospital': 40.0,
        'Wellness Clinic': 55.0,
        'LabCorp': 45.0,
      }
    },
    {
      'name': 'MRI Scan',
      'prices': {
        'City Hospital': 900.0,
        'Wellness Clinic': 700.0,
        'LabCorp': 800.0,
      }
    },
    {
      'name': 'X-Ray',
      'prices': {
        'City Hospital': 100.0,
        'Wellness Clinic': 120.0,
        'LabCorp': 95.0,
      }
    },
    {
      'name': 'Physical Exam',
      'prices': {
        'City Hospital': 60.0,
        'Wellness Clinic': 70.0,
        'LabCorp': 65.0,
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Finance & Budgeting'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.compare, size: 50, color: Colors.blue[700]),
            SizedBox(height: 10),
            Text(
              'Compare Procedure Costs Across Hospitals 🏥',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: procedures.length,
                itemBuilder: (context, index) {
                  final procedure = procedures[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            procedure['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          Divider(),
                          Column(
                            children: hospitals.map((hospital) {
                              final price = procedure['prices'][hospital];
                              return ListTile(
                                leading: Icon(Icons.local_hospital,
                                    color: Colors.blue[600]),
                                title: Text(
                                  hospital,
                                  style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: Text(
                                  '\$${price.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
