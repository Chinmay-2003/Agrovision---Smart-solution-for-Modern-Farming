import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Detection {
  final String label;
  final double confidence;
  final Rect boundingBox;

  Detection({
    required this.label,
    required this.confidence,
    required this.boundingBox,
  });
}

class TFLiteService {
  static const String modelPath = r'D:\agrovision\agrovision\assets\best_float32.tflite';
  static const int inputSize = 640; // YOLOv8 typically uses 640x640
  static const List<String> labels = [
    // Add your 24 classes here
    'Maize','Sugar beet',
  'Soy',
  'Sunflower',
  'Potato',
  'Pea',
  'Bean',
  'Pumpkin',
  'Grasses',
  'Amaranth',
  'Goosefoot',
  'Knotweed',
  'Corn spurry',
  'Chickweed',
  'Solanales',
  'Potato weed',
  'Chamomile',
  'Thistle',
  'Mercuries',
  'Geranium',
  'Crucifer',
  'Poppy',
  'Plantago',
  'Labiate' // Replace with your actual class names
    // ...rest of your classes
  ];

  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      print('Model loaded successfully');
    } catch (e) { 
      print('Failed to load model: $e');
    }
  }

  Future<List<Detection>> detectImage(File image) async {
    if (_interpreter == null) {
      await loadModel();
    }

    // Decode and resize image
    img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
    if (originalImage == null) return [];
    
    final img.Image resizedImage = img.copyResize(
      originalImage,
      width: inputSize,
      height: inputSize,
    );

    // Convert image to input tensor format
    Uint8List inputBytes = Uint8List(1 * inputSize * inputSize * 3);
    int pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = resizedImage.getPixel(x, y);
        inputBytes[pixelIndex++] = pixel.r.toInt(); // Convert num/double to int
        inputBytes[pixelIndex++] = pixel.g.toInt(); // Convert num/double to int
        inputBytes[pixelIndex++] = pixel.b.toInt(); // Convert num/double to int

      }
    }

    // Reshape input tensor
    List<List<List<List<int>>>> inputTensor = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (_) => List.generate(
          inputSize,
          (_) => List.generate(3, (_) => 0),
        ),
      ),
    );

    pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        inputTensor[0][y][x][0] = inputBytes[pixelIndex++];
        inputTensor[0][y][x][1] = inputBytes[pixelIndex++];
        inputTensor[0][y][x][2] = inputBytes[pixelIndex++];
      }
    }

    // Output tensor shape depends on your YOLOv8 export format
    // Adjust these dimensions according to your specific model
    var outputShape = [1, 8400, 28]; // 24 classes + 4 box coordinates
    var outputBuffer = List.filled(1 * 8400 * 28, 0.0).reshape(outputShape);

    // Run inference
    _interpreter!.run(inputTensor, outputBuffer);

    // Process results
    List<Detection> detections = [];
    
    double imgWidth = originalImage.width.toDouble();
    double imgHeight = originalImage.height.toDouble();
    double scaleX = imgWidth / inputSize;
    double scaleY = imgHeight / inputSize;

    // Parse the output tensor (adjust based on your model's specific output format)
    for (int i = 0; i < 8400; i++) {
      // Get class scores (starts at index 4 after box coordinates)
      int classId = 0;
      double maxScore = 0.0;
      
      for (int c = 0; c < 24; c++) {  // Iterate through your 24 classes
        double score = outputBuffer[0][i][c + 4];
        if (score > maxScore) {
          maxScore = score;
          classId = c;
        }
      }
      
      // Filter by confidence threshold
      if (maxScore > 0.5) {  // Adjust threshold as needed
        // Get bounding box coordinates (depends on your model format)
        double x = outputBuffer[0][i][0]; 
        double y = outputBuffer[0][i][1];
        double w = outputBuffer[0][i][2]; 
        double h = outputBuffer[0][i][3];
        
        // Convert to actual image coordinates
        double xmin = (x - w/2) * scaleX;
        double ymin = (y - h/2) * scaleY;
        double width = w * scaleX;
        double height = h * scaleY;
        
        detections.add(Detection(
          label: labels[classId],
          confidence: maxScore,
          boundingBox: Rect.fromLTWH(xmin, ymin, width, height),
        ));
      }
    }
    
    return detections;
  }

  void dispose() {
    _interpreter?.close();
  }
}