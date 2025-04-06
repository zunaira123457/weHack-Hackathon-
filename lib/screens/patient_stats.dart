import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // make sure this is at the top!
import 'dart:async'; // for TimeoutException

class PatientStatsScreen extends StatefulWidget {
  @override
  _PatientStatsScreenState createState() => _PatientStatsScreenState();
}

class _PatientStatsScreenState extends State<PatientStatsScreen> {
  List<dynamic> patientRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatientStats();
  }

  Future<void> fetchPatientStats() async {
    final url = Uri.parse('http://10.169.166.234:5000/patients');

    try {
      final response = await http
          .get(url)
          .timeout(Duration(seconds: 10)); // prevent hanging forever

      if (response.statusCode == 200) {
        setState(() {
          patientRecords = json.decode(response.body);
          print(patientRecords); //  Add this line to debug
          isLoading = false;
        });
        print("✅ Patient data fetched successfully.");
      } else {
        print("❌ Server responded with error: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } on SocketException {
      print("🚫 No connection. Check your Wi-Fi or Flask server.");
      setState(() => isLoading = false);
    } on TimeoutException {
      print("⏱️ Request timed out. Flask server took too long to respond.");
      setState(() => isLoading = false);
    } catch (e) {
      print("🚨 Unexpected error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Patient Stats'),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : patientRecords.isEmpty
              ? Center(child: Text('No patient data available!!'))
              : ListView.builder(
                  itemCount: patientRecords.length,
                  itemBuilder: (context, index) {
                    final patient = patientRecords[index];
                    return Card(
                      margin: EdgeInsets.all(12),
                      child: ListTile(
                        title: Text(
                          patient['patient_name'] ?? 'Unnamed',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Patient ID: ${patient['patient_id'] ?? '-'}"),
                            Text("DOB: ${patient['dob'] ?? '-'}"),
                            Text(
                                "Diagnoses: ${(patient['diagnoses'] as List?)?.join(', ') ?? '-'}"),
                            Text(
                                "Medications: ${(patient['medications'] as List?)?.join(', ') ?? '-'}"),
                            Text(
                                "Heart Rate: ${patient['vitals']?['heart_rate'] ?? '-'}"),
                            Text(
                                "Blood Pressure: ${patient['vitals']?['blood_pressure'] ?? '-'}"),
                            Text(
                                "Amount Due: \$${patient['bill']?['amount_due'] ?? '-'}"),
                            Text(
                                "Bill Status: ${patient['bill']?['status'] ?? '-'}"),
                            Text(
                                "Insurance: ${patient['bill']?['insurance']?['company_name'] ?? '-'}"),
                            Text(
                                "Plan: ${patient['bill']?['insurance']?['plan'] ?? '-'}"),
                            Text(
                                "Office Visit Copay: \$${patient['bill']?['copayments']?['office_visit'] ?? '-'}"),
                            Text(
                                "Prescription Copay: \$${patient['bill']?['copayments']?['prescription'] ?? '-'}"),
                            Text(
                                "Emergency Room Copay: \$${patient['bill']?['copayments']?['emergency_room'] ?? '-'}"),
                            Text(
                                "Out-of-Pocket Max: \$${patient['bill']?['copayments']?['out_of_pocket_max'] ?? '-'}"),
                            SizedBox(height: 8),
                            Text("Lab Results:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ...((patient['lab_results'] ?? []) as List)
                                .map<Widget>((lab) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          "- ${lab['lab_test_name']}: ${lab['result']} (${lab['date']})"),
                                    )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
