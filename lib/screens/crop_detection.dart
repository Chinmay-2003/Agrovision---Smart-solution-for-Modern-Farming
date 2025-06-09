import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CropDetectionPage extends StatefulWidget {
  const CropDetectionPage({Key? key}) : super(key: key);

  @override
  State<CropDetectionPage> createState() => _CropDetectionPageState();
}

class _CropDetectionPageState extends State<CropDetectionPage> {
  File? _image;
  List<dynamic> _detections = [];
  bool _isLoading = false;

  final String apiUrl = "http://<YOUR-IP>:5000/predict"; // or Render/Ngrok URL

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detections = [];
      });
    }
  }

  Future<void> _detectImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      setState(() {
        _detections = json.decode(resBody);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Detection failed")),
      );
    }
  }

  Widget _buildDetectionList() {
    if (_detections.isEmpty) return const Text("No detections yet.");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _detections.length,
      itemBuilder: (context, index) {
        final det = _detections[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.eco),
            title: Text(det['class_name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Confidence: ${(det['confidence'] * 100).toStringAsFixed(2)}%"),
                Text("Info: ${det['description']}"),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Detection"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detect crops and weeds using an AI model. Tap a button to choose an image and view detected items along with summaries.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _image != null
                ? Image.file(_image!, height: 250)
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _detectImage,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Detect"),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Detection Results:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildDetectionList(),
          ],
        ),
      ),
    );
  }
}
