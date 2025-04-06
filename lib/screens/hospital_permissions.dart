import 'package:flutter/material.dart';
import 'permissions_model.dart';

class HospitalPermissionsScreen extends StatefulWidget {
  const HospitalPermissionsScreen({super.key});

  @override
  _HospitalPermissionsScreenState createState() =>
      _HospitalPermissionsScreenState();
}

class _HospitalPermissionsScreenState extends State<HospitalPermissionsScreen> {
  final PermissionsModel _permissionsModel = PermissionsModel();
  late List<PatientData> patients;
  PatientData? selectedPatient;

  @override
  void initState() {
    super.initState();
    // Listen for changes to permissions
    _loadPatients();
    
    // Add listener to refresh UI when permissions change
    _permissionsModel.addListener(_onPermissionsChanged);
  }
  
  @override
  void dispose() {
    // Clean up listener when the screen is disposed
    _permissionsModel.removeListener(_onPermissionsChanged);
    super.dispose();
  }
  
  void _onPermissionsChanged() {
    // Refresh patient data when permissions change
    setState(() {
      _loadPatients();
      
      // Re-select the current patient if they still exist
      if (selectedPatient != null) {
        final patientId = selectedPatient!.id;
        
        // Find the patient in the updated list
        final matchingPatients = patients.where((p) => p.id == patientId).toList();
        
        if (matchingPatients.isNotEmpty) {
          // If the current patient still exists, keep them selected
          selectedPatient = matchingPatients.first;
        } else if (patients.isNotEmpty) {
          // If the current patient doesn't exist but there are other patients, select the first one
          selectedPatient = patients.first;
        } else {
          // If there are no patients at all, set selectedPatient to null
          selectedPatient = null;
        }
      }
    });
  }
  
  void _loadPatients() {
    patients = _permissionsModel.getAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Patient Statistics & Data Access'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient dropdown selector at the top
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patients',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<PatientData>(
                    isExpanded: true,
                    value: selectedPatient,
                    hint: const Text('Select a patient'),
                    underline: const SizedBox(), // Remove the default underline
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    onChanged: (PatientData? newValue) {
                      setState(() {
                        selectedPatient = newValue;
                      });
                    },
                    items: patients.map<DropdownMenuItem<PatientData>>((PatientData patient) {
                      return DropdownMenuItem<PatientData>(
                        value: patient,
                        child: Text('${patient.name} (${patient.id})'),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Patient data section
          if (selectedPatient != null) ...[
            Expanded(
              child: _buildPatientPermissions(selectedPatient!),
            ),
          ] else ...[
            // Empty state when no patient is selected
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_search,
                      size: 80,
                      color: Colors.blue[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a patient to view their data',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPatientPermissions(PatientData patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    Text(
                      'Patient ID: ${patient.id}',
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Available Patient Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This shows what data you can access based on patient settings',
            style: TextStyle(
              fontSize: 16, 
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 20),
          ...patient.permissions.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Status icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: entry.value ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        entry.value ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Data type label
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                    
                    // Access status label
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: entry.value ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: entry.value ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Text(
                        entry.value ? 'Accessible' : 'Restricted',
                        style: TextStyle(
                          color: entry.value ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Note: Data access is controlled by patient privacy settings',
                      style: TextStyle(color: Colors.amber[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}