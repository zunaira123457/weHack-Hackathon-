import 'package:flutter/material.dart';

// This class manages the permission data and notifies listeners when it changes
class PermissionsModel extends ChangeNotifier {
  // Singleton pattern to ensure we have only one instance
  static final PermissionsModel _instance = PermissionsModel._internal();

  factory PermissionsModel() {
    return _instance;
  }

  PermissionsModel._internal();

  // Map of patients and their permissions
  // The outer key is patientId, and the inner map contains permission settings
  final Map<String, Map<String, bool>> _patientPermissions = {
    'P10023': {
      'Vitals': true,
      'Medications': false,
      'Lab Results': true,
      'Allergies': false,
      'Appointments': true,
      'Billing Info': false,
    },
    'P10045': {
      'Vitals': true,
      'Medications': true,
      'Lab Results': true,
      'Allergies': true,
      'Appointments': true,
      'Billing Info': false,
    },
    'P10089': {
      'Vitals': true,
      'Medications': false,
      'Lab Results': false,
      'Allergies': true,
      'Appointments': true,
      'Billing Info': false,
    },
  };

  // Current user ID (in a real app, this would be set at login)
  String _currentPatientId = 'P10023';

  // Get permissions for the current user
  Map<String, bool> get currentUserPermissions {
    return Map.from(_patientPermissions[_currentPatientId] ?? {});
  }

  // Get permissions for a specific patient
  Map<String, bool> getPatientPermissions(String patientId) {
    return Map.from(_patientPermissions[patientId] ?? {});
  }

  // Set current user ID
  void setCurrentPatientId(String patientId) {
    _currentPatientId = patientId;
    notifyListeners();
  }

  // Update a permission for the current user
  void updatePermission(String permissionKey, bool value) {
    if (_patientPermissions.containsKey(_currentPatientId)) {
      _patientPermissions[_currentPatientId]![permissionKey] = value;
      notifyListeners();
    }
  }

  // Get all patients with their permissions
  List<PatientData> getAllPatients() {
    List<PatientData> patients = [];

    // This would typically come from a database
    final Map<String, String> patientNames = {
      'P10023': 'John Smith',
      'P10045': 'Sarah Johnson',
      'P10089': 'Michael Brown',
    };

    _patientPermissions.forEach((patientId, permissions) {
      patients.add(
        PatientData(
          id: patientId,
          name: patientNames[patientId] ?? 'Unknown Patient',
          permissions: Map.from(permissions),
        ),
      );
    });

    return patients;
  }
}

// Patient data model
class PatientData {
  final String id;
  final String name;
  final Map<String, bool> permissions;

  PatientData({
    required this.id,
    required this.name,
    required this.permissions,
  });
}