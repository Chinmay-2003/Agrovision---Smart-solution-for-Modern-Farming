import 'package:flutter/material.dart';

class CropRecommendation extends StatefulWidget {
  const CropRecommendation({super.key});

  @override
  State<CropRecommendation> createState() => _CropRecommendationState();
}

class _CropRecommendationState extends State<CropRecommendation> {
  final _formKey = GlobalKey<FormState>();
  double temperature = 25;
  double humidity = 50;
  double rainfall = 100;
  double ph = 7;
  double potassium = 40;
  double nitrogen = 40;
  double phosphorus = 40;
  String? recommendedCrop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Recommendation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSlider('Temperature (°C)', temperature, 0, 50,
                  (value) => setState(() => temperature = value)),
              _buildSlider('Humidity (%)', humidity, 0, 100,
                  (value) => setState(() => humidity = value)),
              _buildSlider('Rainfall (mm)', rainfall, 0, 300,
                  (value) => setState(() => rainfall = value)),
              _buildSlider('pH', ph, 0, 14,
                  (value) => setState(() => ph = value)),
              _buildSlider('Potassium (K)', potassium, 0, 100,
                  (value) => setState(() => potassium = value)),
              _buildSlider('Nitrogen (N)', nitrogen, 0, 100,
                  (value) => setState(() => nitrogen = value)),
              _buildSlider('Phosphorus (P)', phosphorus, 0, 100,
                  (value) => setState(() => phosphorus = value)),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _recommendCrop,
                  child: const Text('Find Best Crop'),
                ),
              ),
              if (recommendedCrop != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Recommended Crop: $recommendedCrop',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _recommendCrop() {
    // This is a placeholder for the ML model integration
    // In a real app, you would call your ML model here
    setState(() {
      recommendedCrop = 'Rice'; // Example recommendation
    });
  }
}