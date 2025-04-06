import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model classes
class BillingProcedure {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final String status;

  BillingProcedure({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.status,
  });
}

class PatientBilling {
  final String patientId;
  final String patientName;
  final List<BillingProcedure> procedures;

  PatientBilling({
    required this.patientId,
    required this.patientName,
    required this.procedures,
  });

  double get totalBilled => procedures.fold(0, (sum, proc) => sum + proc.amount);
  
  double get totalPaid => procedures
      .where((proc) => proc.status.toLowerCase() == 'paid')
      .fold(0, (sum, proc) => sum + proc.amount);
  
  double get totalPending => totalBilled - totalPaid;
}

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({Key? key}) : super(key: key);

  @override
  _BillingHistoryScreenState createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  final List<PatientBilling> _allBillingData = [
    PatientBilling(
      patientId: 'P001',
      patientName: 'John Doe',
      procedures: [
        BillingProcedure(
          id: 'B1001', 
          date: DateTime(2025, 3, 12), 
          description: 'Consultation', 
          amount: 150.00, 
          status: 'paid'
        ),
        BillingProcedure(
          id: 'B1002', 
          date: DateTime(2025, 3, 15), 
          description: 'Blood Test', 
          amount: 75.50, 
          status: 'paid'
        ),
        BillingProcedure(
          id: 'B1003', 
          date: DateTime(2025, 4, 1), 
          description: 'Follow-up', 
          amount: 120.00, 
          status: 'pending'
        ),
      ],
    ),
    PatientBilling(
      patientId: 'P002',
      patientName: 'Jane Smith',
      procedures: [
        BillingProcedure(
          id: 'B2001', 
          date: DateTime(2025, 2, 28), 
          description: 'X-Ray', 
          amount: 250.00, 
          status: 'paid'
        ),
        BillingProcedure(
          id: 'B2002', 
          date: DateTime(2025, 3, 20), 
          description: 'Physical Therapy', 
          amount: 300.00, 
          status: 'overdue'
        ),
      ],
    ),
    PatientBilling(
      patientId: 'P003',
      patientName: 'Robert Johnson',
      procedures: [
        BillingProcedure(
          id: 'B3001', 
          date: DateTime(2025, 3, 5), 
          description: 'Surgery', 
          amount: 1500.00, 
          status: 'paid'
        ),
        BillingProcedure(
          id: 'B3002', 
          date: DateTime(2025, 3, 25), 
          description: 'Post-op Checkup', 
          amount: 100.00, 
          status: 'paid'
        ),
      ],
    ),
  ];

  List<PatientBilling> _filteredBillingData = [];
  String _searchTerm = '';
  String _sortField = 'patientName';
  bool _sortAscending = true;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _filteredBillingData = List.from(_allBillingData);
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      // First apply search filter
      if (_searchTerm.isEmpty) {
        _filteredBillingData = List.from(_allBillingData);
      } else {
        _filteredBillingData = _allBillingData
            .where((patient) =>
                patient.patientName.toLowerCase().contains(_searchTerm.toLowerCase()) ||
                patient.patientId.toLowerCase().contains(_searchTerm.toLowerCase()))
            .toList();
      }

      // Apply status filter if needed
      if (_statusFilter != 'all') {
        // Filter patients that have at least one procedure with the selected status
        _filteredBillingData = _filteredBillingData
            .where((patient) => patient.procedures
                .any((proc) => proc.status.toLowerCase() == _statusFilter.toLowerCase()))
            .toList();
      }

      // Apply sorting
      _filteredBillingData.sort((a, b) {
        int compareResult;
        
        switch (_sortField) {
          case 'patientName':
            compareResult = a.patientName.compareTo(b.patientName);
            break;
          case 'patientId':
            compareResult = a.patientId.compareTo(b.patientId);
            break;
          case 'procedureCount':
            compareResult = a.procedures.length.compareTo(b.procedures.length);
            break;
          case 'totalBilled':
            compareResult = a.totalBilled.compareTo(b.totalBilled);
            break;
          default:
            compareResult = 0;
        }
        
        return _sortAscending ? compareResult : -compareResult;
      });
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showPatientDetails(PatientBilling patient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.patientName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Patient ID: ${patient.patientId}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // List of procedures
                      for (var procedure in patient.procedures)
                        Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(procedure.description),
                            subtitle: Text(
                              DateFormat('MMM dd, yyyy').format(procedure.date),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${procedure.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(procedure.status).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    procedure.status,
                                    style: TextStyle(
                                      color: _getStatusColor(procedure.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Total Billed:', patient.totalBilled),
                    const SizedBox(height: 4),
                    _buildSummaryRow('Total Paid:', patient.totalPaid),
                    const SizedBox(height: 4),
                    _buildSummaryRow('Balance Due:', patient.totalPending),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text('Print'),
                    onPressed: () {
                      // Implement print functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Print functionality coming soon')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Billing History'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          // Search and filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search patients...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                      _applyFilters();
                    });
                  },
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      _buildFilterChip('Paid', 'paid'),
                      _buildFilterChip('Pending', 'pending'),
                      _buildFilterChip('Overdue', 'overdue'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  flex: 3, // Slightly reduced from original
                  child: _buildSortableHeader('Patient ID', 'patientId'),
                ),
                Expanded(
                  flex: 4, // Slightly reduced from original
                  child: _buildSortableHeader('Name', 'patientName'),
                ),
                Expanded(
                  flex: 2, // Kept the same
                  child: _buildSortableHeader('Procedures', 'procedureCount'),
                ),
                Expanded(
                  flex: 3, // Slightly reduced from original
                  child: _buildSortableHeader('Total', 'totalBilled'),
                ),
                Expanded(
                  flex: 3, // Increased for the action button
                  child: const Center(
                    child: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // List of patients
          Expanded(
            child: _filteredBillingData.isEmpty
                ? Center(
                    child: Text(
                      'No billing records found',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredBillingData.length,
                    itemBuilder: (context, index) {
                      final patient = _filteredBillingData[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3, // Match header flex
                                child: Text(
                                  patient.patientId,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 4, // Match header flex
                                child: Text(
                                  patient.patientName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2, // Match header flex
                                child: Center(
                                  child: Text(
                                    patient.procedures.length.toString(),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3, // Match header flex
                                child: Text(
                                  '\$${patient.totalBilled.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 3, // Match header flex
                                child: Center(
                                  child: SizedBox(
                                    height: 32, // Fixed height for button
                                    child: ElevatedButton(
                                      onPressed: () => _showPatientDetails(patient),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[700],
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      child: const Text('Details'),
                                    ),
                                  ),
                                ),
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
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _statusFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _statusFilter = selected ? value : 'all';
            _applyFilters();
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
        checkmarkColor: Colors.blue[800],
      ),
    );
  }

  Widget _buildSortableHeader(String label, String field) {
    final isSorted = _sortField == field;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_sortField == field) {
            _sortAscending = !_sortAscending;
          } else {
            _sortField = field;
            _sortAscending = true;
          }
          _applyFilters();
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isSorted)
            Icon(
              _sortAscending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
            ),
        ],
      ),
    );
  }
}