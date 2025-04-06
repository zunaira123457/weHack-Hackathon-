import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CreditCardScanner extends StatefulWidget {
  @override
  _CreditCardScannerState createState() => _CreditCardScannerState();
}

class _CreditCardScannerState extends State<CreditCardScanner> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  String _scannedText = "Scanned card data will show here.";

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

      Navigator.pop(context, recognizedText.text); // ⬅️ Return to billing screen
    } catch (e) {
      setState(() {
        _scannedText = "⚠️ Error scanning: $e";
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Credit Card'),
        backgroundColor: Colors.blue[700],
      ),
      body: _isCameraInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _captureAndScanImage,
                  icon: Icon(Icons.credit_card),
                  label: Text("Scan Card"),
                )
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}