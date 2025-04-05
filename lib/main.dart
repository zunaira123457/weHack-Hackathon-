import 'package:flutter/material.dart';
import 'screens/patient_portal.dart';
import 'screens/hospital_portal.dart';
//import 'screens/patient_permissions.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'MediMesh',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.blue[100],
    ),
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String userType = 'patient'; // default selection

  void handleLogin() {
    if (userType == 'hospital') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HospitalPortal()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PatientPortal()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to MediMesh',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("I am a:",
                    style: TextStyle(fontSize: 16, color: Colors.blue[900])),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: userType,
                  onChanged: (String? value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'patient',
                      child: Text('Patient'),
                    ),
                    DropdownMenuItem(
                      value: 'hospital',
                      child: Text('Hospital'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleLogin,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blue[800],
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
