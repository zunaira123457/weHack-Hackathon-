import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionPage extends StatefulWidget {
  @override
  _SpeechRecognitionPageState createState() => _SpeechRecognitionPageState();
}

class _SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "Press the microphone and start speaking";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _spokenText = val.recognizedWords;
          });

          if (val.hasConfidenceRating && val.confidence > 0.7) {
            _handleVoiceCommand(val.recognizedWords);
          }
        },
      );
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _handleVoiceCommand(String command) {
    final normalized = command.toLowerCase();

    if (normalized.contains("billing") || normalized.contains("bill")) {
      Navigator.pushNamed(context, '/billing');
    } else if (normalized.contains("permission")) {
      Navigator.pushNamed(context, '/permissions');
    } else if (normalized.contains("finance") || normalized.contains("money")) {
      Navigator.pushNamed(context, '/finance');
    } else if (normalized.contains("stats") || normalized.contains("health")) {
      Navigator.pushNamed(context, '/stats');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Sorry, I didn’t understand that.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Voice Input'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.grey,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _spokenText,
              style: const TextStyle(fontSize: 22.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isListening ? _stopListening : _startListening,
              icon: Icon(_isListening ? Icons.stop : Icons.mic),
              label: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
