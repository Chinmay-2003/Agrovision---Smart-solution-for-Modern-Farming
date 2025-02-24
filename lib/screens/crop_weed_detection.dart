import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'dart:io';

class CropWeedDetection extends StatefulWidget {
  const CropWeedDetection({super.key});

  @override
  State<CropWeedDetection> createState() => _CropWeedDetectionState();
}

class _CropWeedDetectionState extends State<CropWeedDetection> {
  File? _image;
  final _picker = ImagePicker();
  Map<String, dynamic>? _detectionResult;
  bool _isProcessing = false;
  final ImageLabeler _imageLabeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.5),
  );

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detectionResult = null;
      });
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final inputImage = InputImage.fromFile(_image!);
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);

      // Process detection results
      final List<Map<String, dynamic>> detections = [];
      
      for (ImageLabel label in labels) {
        final String text = label.label.toLowerCase();
        final double confidence = label.confidence;
        
        // Categorize the detection
        Color color;
        String info;
        
        if (text.contains('plant') || text.contains('crop') || 
            text.contains('agriculture') || text.contains('farm')) {
          color = Colors.green;
          info = 'Detected crop or plant. Confidence: ${(confidence * 100).toStringAsFixed(1)}%';
        } else if (text.contains('weed') || text.contains('grass') || 
                  text.contains('wild') || text.contains('herb')) {
          color = Colors.red;
          info = 'Possible weed detected. Consider inspection. Confidence: ${(confidence * 100).toStringAsFixed(1)}%';
        } else {
          color = Colors.blue;
          info = 'Other object detected. Confidence: ${(confidence * 100).toStringAsFixed(1)}%';
        }

        detections.add({
          'label': text,
          'color': color,
          'count': 1,
          'info': info,
          'confidence': confidence,
        });
      }

      setState(() {
        _detectionResult = {
          'detections': detections,
        };
      });
    } catch (e) {
      print('Error processing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error processing image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop & Weed Detection'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title and Instructions
            Text(
              'Crop & Weed Detection',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to use:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Select an image from gallery or take a photo'),
                  Text('2. Wait for the detection process to complete'),
                  Text('3. View detected crops and weeds with color coding'),
                  Text('4. Check detailed information below the results'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Image Input Area
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _image == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, 
                            size: 64, 
                            color: Theme.of(context).colorScheme.primary
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _getImage(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Gallery'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () => _getImage(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Camera'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        Image.file(
                          _image!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        if (_detectionResult != null)
                          CustomPaint(
                            painter: DetectionBoxPainter(_detectionResult!),
                            size: const Size(double.infinity, double.infinity),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            if (_image != null)
              FilledButton(
                onPressed: _isProcessing ? null : _processImage,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Analyze Image'),
              ),

            // Results
            if (_detectionResult != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Detection Results:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...(_detectionResult!['detections'] as List).map((detection) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: detection['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              detection['label'].toString().toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(detection['info']),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}

class DetectionBoxPainter extends CustomPainter {
  final Map<String, dynamic> detectionResult;

  DetectionBoxPainter(this.detectionResult);

  @override
  void paint(Canvas canvas, Size size) {
    final detections = detectionResult['detections'] as List;
    final random = DateTime.now().millisecondsSinceEpoch;

    for (var i = 0; i < detections.length; i++) {
      final detection = detections[i];
      final paint = Paint()
        ..color = detection['color']
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // Simulate different positions for boxes based on detection
      final left = (random + i * 50) % (size.width - 100);
      final top = (random + i * 70) % (size.height - 100);
      final rect = Rect.fromLTWH(left, top, 100, 100);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}