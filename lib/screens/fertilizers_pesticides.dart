import 'package:flutter/material.dart';

class FertilizersPesticides extends StatefulWidget {
  const FertilizersPesticides({super.key});

  @override
  State<FertilizersPesticides> createState() => _FertilizersPesticidesState();
}

class _FertilizersPesticidesState extends State<FertilizersPesticides> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedPlant;

  final Map<String, Map<String, List<String>>> _recommendations = {
    'rice': {
      'fertilizers': ['Urea', 'DAP', 'Potash'],
      'pesticides': ['Carbofuran', 'Chlorpyrifos'],
    },
    'wheat': {
      'fertilizers': ['NPK', 'Urea', 'Zinc Sulfate'],
      'pesticides': ['Propiconazole', 'Tebuconazole'],
    },
    // Add more plants and recommendations
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fertilizers & Pesticides')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a plant',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchPlant(_searchController.text),
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: _searchPlant,
            ),
            const SizedBox(height: 20),
            if (_selectedPlant != null) ...[
              Text(
                'Recommendations for ${_selectedPlant!}:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildRecommendationSection('Fertilizers'),
              const SizedBox(height: 10),
              _buildRecommendationSection('Pesticides'),
            ],
          ],
        ),
      ),
    );
  }

  void _searchPlant(String plant) {
    setState(() {
      _selectedPlant = _recommendations.containsKey(plant.toLowerCase())
          ? plant.toLowerCase()
          : null;
    });
  }

  Widget _buildRecommendationSection(String title) {
    if (_selectedPlant == null) return const SizedBox.shrink();

    final recommendations =
        _recommendations[_selectedPlant]![title.toLowerCase()]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        ...recommendations.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text('• $item'),
            )),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}