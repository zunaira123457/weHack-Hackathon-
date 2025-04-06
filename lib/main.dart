import 'package:flutter/material.dart';
import 'screens/patient_portal.dart';
import 'screens/hospital_portal.dart';
import 'screens/patient_permissions.dart';
import 'screens/patient_billing.dart';
import 'screens/patient_finance.dart';
import 'screens/speech_to_text.dart';
import 'screens/insurance_card_scanner.dart';
import 'package:medimesh/screens/patient_stats.dart';

void main() {
  runApp(MediMeshApp());
}

class MediMeshApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediMesh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/patient': (context) => PatientPortal(),
        '/hospital': (context) => HospitalPortal(),
        '/permissions': (context) => PatientPermissionsScreen(),
        '/billing': (context) => PatientBillingScreen(),
        '/finance': (context) => PatientFinanceScreen(),
        '/voice': (context) => SpeechRecognitionPage(),
        '/scanner': (context) => InsuranceCardScanner(),
        '/stats': (context) => PatientStatsScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String userType = 'Patient';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                '🐾 Welcome to MediMesh',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Helping you access your healthcare simply 💙',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'e.g. admin@hospital.com or user@gmail.com',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("I'm a:", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: userType,
                    onChanged: (value) {
                      setState(() {
                        userType = value!;
                      });
                    },
                    items: ['Patient', 'Hospital']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                onPressed: () {
                  String email = emailController.text.toLowerCase();

                  // Hospital login logic
                  bool isHospitalEmail = email.contains('@hospital.com') ||
                      email.contains('admin') ||
                      email.contains('staff') ||
                      email.contains('hospital');

                  if (userType == 'Hospital' && isHospitalEmail) {
                    Navigator.pushNamed(context, '/hospital');
                  } else if (userType == 'Patient' && !isHospitalEmail) {
                    Navigator.pushNamed(context, '/patient');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '🚫 Invalid login. Please use the correct account for your role.',
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                label: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
