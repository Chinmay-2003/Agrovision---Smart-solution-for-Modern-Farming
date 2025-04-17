import 'package:flutter/material.dart';

class SoilAnalyzerPage extends StatefulWidget {
  const SoilAnalyzerPage({super.key});

  @override
  State<SoilAnalyzerPage> createState() => _SoilAnalyzerPageState();
}

class _SoilAnalyzerPageState extends State<SoilAnalyzerPage> {
  final _formKey = GlobalKey<FormState>();
  String color = '';
  String texture = '';
  String smell = '';
  String pastCrops = '';

  String? analysisResult;

  void analyzeSoil() {
    // Dummy logic – you can replace this with AI/ML logic later
    String result = '';

    if (color.toLowerCase().contains('black') && texture.toLowerCase().contains('loamy')) {
      result = '''
✅ pH Range: 6.5 - 7.5
🧪 Possible Deficiencies: Nitrogen
🌾 Suggested Fertilizer: Urea or Compost
''';
    } else if (color.toLowerCase().contains('red') || texture.toLowerCase().contains('sandy')) {
      result = '''
✅ pH Range: 5.5 - 6.5
🧪 Possible Deficiencies: Phosphorus, Organic Matter
🌾 Suggested Fertilizer: DAP, Vermicompost
''';
    } else {
      result = '''
✅ pH Range: 6.0 - 7.0
🧪 Possible Deficiencies: Micronutrients
🌾 Suggested Fertilizer: Balanced NPK + Micronutrient mix
''';
    }

    setState(() {
      analysisResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Health Analyzer'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Soil Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Soil Color (e.g., black, red)'),
                    onChanged: (val) => color = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Soil Texture (e.g., loamy, sandy)'),
                    onChanged: (val) => texture = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Soil Smell (e.g., earthy, pungent)'),
                    onChanged: (val) => smell = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Past Crops (e.g., rice, wheat)'),
                    onChanged: (val) => pastCrops = val,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: analyzeSoil,
                    child: const Text('Analyze Soil'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (analysisResult != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  analysisResult!,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
