import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class InsuranceCardScanner extends StatefulWidget {
  const InsuranceCardScanner({Key? key}) : super(key: key);

  @override
  _InsuranceCardScannerState createState() => _InsuranceCardScannerState();
}

class _InsuranceCardScannerState extends State<InsuranceCardScanner> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  String _scannedText = "Scanned text will appear here.";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras.first, ResolutionPreset.medium);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _captureAndScanImage() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      final image = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      setState(() {
        _scannedText = recognizedText.text.isNotEmpty
            ? recognizedText.text
            : "❌ No text detected on the card.";
      });
    } catch (e) {
      setState(() {
        _scannedText = "⚠️ Error while scanning: $e";
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _confirmAndReturn() {
    if (_scannedText.isNotEmpty &&
        _scannedText != "Scanned text will appear here." &&
        !_scannedText.contains("❌") &&
        !_scannedText.contains("⚠️")) {
      Navigator.pop(context, _scannedText);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🚫 Please scan a valid card before saving."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan Insurance Card',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        actions: [
          TextButton(
            onPressed: _confirmAndReturn,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD0E9FF), Color(0xFF88B8F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              _isCameraInitialized
                  ? AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CameraPreview(_cameraController),
                      ),
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _captureAndScanImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blueAccent.withOpacity(0.4),
                ),
                icon: const Icon(Icons.camera, color: Colors.blueAccent),
                label: const Text(
                  'Scan Insurance Card',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _scannedText,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
