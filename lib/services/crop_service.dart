import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/crop_data.dart';

class CropService {
  static RandomForest? _forest;
  
  static Future<void> initialize() async {
    if (_forest != null) return;

    // Load CSV data
    String csvData = await rootBundle.loadString('assets/crop_data.csv');
    List<CropData> dataset = _parseCsvData(csvData);
    
    // Create and train random forest
    _forest = RandomForest(numTrees: 10);
    _forest!.train(dataset);
  }

  static String getRecommendation({
    required double temperature,
    required double humidity,
    required double rainfall,
    required double ph,
    required double potassium,
    required double nitrogen,
    required double phosphorus,
  }) {
    if (_forest == null) {
      throw Exception('CropService not initialized');
    }

    List<double> features = [
      temperature,
      humidity,
      rainfall,
      ph,
      potassium,
      nitrogen,
      phosphorus,
    ];

    return _forest!.predict(features);
  }

  static List<CropData> _parseCsvData(String csvData) {
    List<CropData> dataset = [];
    List<String> lines = LineSplitter.split(csvData).toList();
    
    // Skip header row
    for (int i = 1; i < lines.length; i++) {
      List<String> values = lines[i].split(',');
      if (values.length == 8) {
        dataset.add(CropData(
          temperature: double.parse(values[0]),
          humidity: double.parse(values[1]),
          rainfall: double.parse(values[2]),
          ph: double.parse(values[3]),
          potassium: double.parse(values[4]),
          nitrogen: double.parse(values[5]),
          phosphorus: double.parse(values[6]),
          crop: values[7].trim(),
        ));
      }
    }
    return dataset;
  }
}