import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CropWeedDetectionApp());
}

class CropWeedDetectionApp extends StatelessWidget {
  const CropWeedDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const CropWeedDetectionScreen(),
    );
  }
}

class CropWeedDetectionScreen extends StatefulWidget {
  const CropWeedDetectionScreen({super.key});

  @override
  State<CropWeedDetectionScreen> createState() =>
      _CropWeedDetectionScreenState();
}

class _CropWeedDetectionScreenState extends State<CropWeedDetectionScreen> {
  File? _image;
  bool _isDetected = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isDetected = false;
      });
    }
  }

  void _detectImage() {
    setState(() {
      _isDetected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop and Weed Detection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Instruction Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'How it works:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '• Select an image from the gallery or take a new one.',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  Text(
                    '• Tap "Detect" to analyze and identify crops or weeds.',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  Text(
                    '• The app will show the detected image and crop/weed details.',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Image Picker Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Image Display
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _isDetected
                    ? Image.asset(
                        'assets/xyz.jpg',
                        fit: BoxFit.cover,
                      )
                    : _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 24),

            // Detect Button
            ElevatedButton(
              onPressed: _image != null ? _detectImage : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 40,
                ),
              ),
              child: const Text(
                'Detect',
                style: TextStyle(fontSize: 16),
              ),
            ),
                        const SizedBox(height: 24),

            // Result Text (shown only after detection)
            if (_isDetected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Detection Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Crop:',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      '  • Sugarbeet : 6',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Weed:',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      '  • Total Weeds : 2',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
