import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class PlantDetails {
  final String name;
  final String scientificName;
  final String growingConditions;
  final List<FertilizerInfo> fertilizers;
  final List<PesticideInfo> pesticides;

  PlantDetails({
    required this.name,
    required this.scientificName,
    required this.growingConditions,
    required this.fertilizers,
    required this.pesticides,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    return PlantDetails(
      name: json['name'] ?? '',
      scientificName: json['scientificName'] ?? '',
      growingConditions: json['growingConditions'] ?? '',
      fertilizers: (json['fertilizers'] as List? ?? [])
          .map((f) => FertilizerInfo.fromJson(f))
          .toList(),
      pesticides: (json['pesticides'] as List? ?? [])
          .map((p) => PesticideInfo.fromJson(p))
          .toList(),
    );
  }
}

class FertilizerInfo {
  final String name;
  final String type;
  final String npkRatio;
  final String purpose;

  FertilizerInfo({
    required this.name,
    required this.type,
    required this.npkRatio,
    required this.purpose,
  });

  factory FertilizerInfo.fromJson(Map<String, dynamic> json) {
    return FertilizerInfo(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      npkRatio: json['npkRatio'] ?? '',
      purpose: json['purpose'] ?? '',
    );
  }
}

class PesticideInfo {
  final String name;
  final String type;
  final String targetPests;
  final String modeOfAction;

  PesticideInfo({
    required this.name,
    required this.type,
    required this.targetPests,
    required this.modeOfAction,
  });

  factory PesticideInfo.fromJson(Map<String, dynamic> json) {
    return PesticideInfo(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      targetPests: json['targetPests'] ?? '',
      modeOfAction: json['modeOfAction'] ?? '',
    );
  }
}

class FertilizersPesticides extends StatefulWidget {
  const FertilizersPesticides({super.key});

  @override
  State<FertilizersPesticides> createState() => _FertilizersPesticidesState();
}

class _FertilizersPesticidesState extends State<FertilizersPesticides> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, PlantDetails> _plantData = {};
  List<String> _searchResults = [];
  String? _selectedPlant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJSONData();
  }

  Future<void> _loadJSONData() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/plant_data.json');
      final List<dynamic> data = json.decode(jsonData);
      
      Map<String, PlantDetails> tempData = {};
      for (var item in data) {
        final plant = PlantDetails.fromJson(item);
        tempData[plant.name.toLowerCase()] = plant;
      }

      setState(() {
        _plantData = tempData;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading JSON: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchPlant(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _selectedPlant = null;
      });
      return;
    }

    final searchLower = query.trim().toLowerCase();
    setState(() {
      _searchResults = _plantData.keys
          .where((plant) => plant.contains(searchLower))
          .toList();
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plant Care Guide',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Find detailed information about plants, including:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildInfoPoint(Icons.eco, 'Growing conditions and requirements'),
          _buildInfoPoint(Icons.science, 'Recommended fertilizers and NPK ratios'),
          _buildInfoPoint(Icons.bug_report, 'Pest control solutions'),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _searchPlant,
              decoration: InputDecoration(
                hintText: 'Search for a plant...',
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _searchPlant('');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _searchResults.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final plant = _plantData[_searchResults[index]]!;
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.eco),
              ),
              title: Text(
                plant.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                plant.scientificName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedPlant = _searchResults[index];
                  _searchController.text = plant.name;
                  _searchResults = [];
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlantDetails() {
    if (_selectedPlant == null) return const SizedBox.shrink();

    final plant = _plantData[_selectedPlant]!;

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildInfoCard(
            'Plant Information',
            [
              _buildInfoRow('Name', plant.name),
              _buildInfoRow('Scientific Name', plant.scientificName),
              _buildInfoRow('Growing Conditions', plant.growingConditions),
            ],
          ),
          const SizedBox(height: 16),
          _buildFertilizersList(plant.fertilizers),
          const SizedBox(height: 16),
          _buildPesticidesList(plant.pesticides),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 68, 67, 67)),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black))),
        ],
      ),
    );
  }

  Widget _buildFertilizersList(List<FertilizerInfo> fertilizers) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Fertilizers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...fertilizers.map((fertilizer) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildInfoRow('Name', fertilizer.name),
                _buildInfoRow('Type', fertilizer.type),
                _buildInfoRow('NPK Ratio', fertilizer.npkRatio),
                _buildInfoRow('Purpose', fertilizer.purpose),
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPesticidesList(List<PesticideInfo> pesticides) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bug_report,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Pesticides',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...pesticides.map((pesticide) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildInfoRow('Name', pesticide.name),
                _buildInfoRow('Type', pesticide.type),
                _buildInfoRow('Target Pests', pesticide.targetPests),
                _buildInfoRow('Mode of Action', pesticide.modeOfAction),
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 8),
                    _buildSearchResults(),
                    if (_selectedPlant != null) _buildPlantDetails(),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}