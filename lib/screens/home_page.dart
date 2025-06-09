  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
  import '../models/feedback.dart';
  import 'crop_recommendation.dart';
  import 'fertilizers_pesticides.dart';
  import 'government_schemes.dart';
  import 'profile_page.dart';
  import '../widgets/custom_app_bar.dart';
  import '../widgets/custom_footer.dart';
  import 'crop_detection.dart';
  //import 'crop_weed_detection.dart';
  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:geolocator/geolocator.dart';
  import 'SoilAnalyzerPage.dart';
  import 'krish.dart';

  class HomePage extends StatefulWidget {
    final String username;

    const HomePage({super.key, required this.username});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    late String _timeString;
    final TextEditingController _feedbackController = TextEditingController();
    final List<UserFeedback> _feedbacks = [];
    String? _temperature;
    String? _humidity;
    String? _weatherCondition;
    
    @override
    void initState() {
      super.initState();
      _timeString = _formatDateTime(DateTime.now());
      _getWeather();
      Stream.periodic(const Duration(minutes: 1)).listen((_) {
        setState(() {
          _timeString = _formatDateTime(DateTime.now());
        });
      });
    }

    String _formatDateTime(DateTime dateTime) {
      return DateFormat('hh:mm a').format(dateTime);
    }

    void _addFeedback() {
      if (_feedbackController.text.isNotEmpty) {
        setState(() {
          _feedbacks.add(UserFeedback(
            username: widget.username,
            message: _feedbackController.text,
            timestamp: DateTime.now(),
          ));
          _feedbackController.clear();
        });
      }
    }
    Future<void> _getWeather() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      String apiKey = '140043d3483e848ba2cc6ad1aa036e56'; // 🔑 Replace with your real API key
      String url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _temperature = data['main']['temp'].toString();
          _humidity = data['main']['humidity'].toString();
          _weatherCondition = data['weather'][0]['main'];
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8E2DE2),
                  Color(0xFF4A00E0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🌾 Gradient Title
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Agrovision',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Required for ShaderMask
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    // 👤 Glowing Profile Button
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(username: widget.username),
                        ),
                      ),
                      child: Hero(
                        tag: 'profile',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.6),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.purple[300],
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        body: Stack(
          children: [
            // Background with purple patches
            CustomPaint(
              size: Size.infinite,
              painter: BackgroundPainter(),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time and Plant Icon
                  Row(
                    children: [
                      Text(
                        _timeString,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.local_florist,
                        size: 16,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Hello and Username with Farmer Image
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Side: Greeting + Username
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 209, 52, 236),
                                  Color.fromARGB(255, 72, 173, 255),
                                  Colors.green,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                widget.username,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right Side: Full Image without styling
                      Image.asset(
                        'assets/images/home.png',
                        width: 200,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),


                  const SizedBox(height: 32),
                  // App Logo and Description
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(75),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.eco,
                                    color: Colors.purple,
                                    size: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Agrovision',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            'Your intelligent farming companion that helps you make data-driven decisions. Get personalized crop recommendations, find the right fertilizers, and stay updated with government schemes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Colors.purple, Colors.deepPurpleAccent],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            '💬 Ask Krish',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Masked by gradient
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const krish()),
                            );
                          },
                          icon: const Icon(Icons.chat_rounded, size: 20),
                          label: const Text(
                            "Chat Now",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent.shade400,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.purpleAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 32),

                  if (_temperature != null && _humidity != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.3),
                            Colors.deepPurple.withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.25),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.4),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.wb_sunny_outlined, color: Colors.amberAccent, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Live Weather Conditions',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.purpleAccent,
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.thermostat_outlined, color: Colors.redAccent.shade100),
                              const SizedBox(width: 8),
                              Text(
                                'Temperature: $_temperature°C',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.water_drop_outlined, color: Colors.lightBlueAccent),
                              const SizedBox(width: 8),
                              Text(
                                'Humidity: $_humidity%',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.cloud_outlined, color: Colors.grey.shade400),
                              const SizedBox(width: 8),
                              Text(
                                'Condition: $_weatherCondition',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Feature Buttons
                  ...['Crop & Weed Detection', 'Crop Recommendation', 'Fertilizers & Pesticides', 'Government Schemes',  'Soil Health Analyzer']
                      .asMap()
                      .entries
                      .map((entry) {
                    final icons = [Icons.camera_alt, Icons.grass, Icons.science, Icons.policy, Icons.eco];
                    final routes = [
                      //DetectionScreen(),
                      const CropDetectionPage(),
                      const CropRecommendation(),
                      const FertilizersPesticides(),
                      const GovernmentSchemes(),
                      const SoilAnalyzerPage()
                    ];
                    final descriptions = [
                      'Detect weeds and crops in youur field',
                      'Get AI-powered crop suggestions',
                      'Find the right products for your crops',
                      'Explore available farming schemes',
                      'Analyze soil & get expert suggestions'
                    ];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildFeatureButton(
                        context,
                        entry.value,
                        icons[entry.key],
                        descriptions[entry.key],
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => routes[entry.key]),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 32),
                  // Feedback Section
                  if (_feedbacks.isNotEmpty) ...[
                    const Text(
                      'User Feedback',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: FlutterCarousel(
                        options: FlutterCarouselOptions(
                          height: 150,
                          showIndicator: false,
                          viewportFraction: 0.9,
                          enableInfiniteScroll: false,
                        ),
                        items: _feedbacks.map((feedback) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.purple.withOpacity(0.3),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedback.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  feedback.message,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // Feedback Input
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Share Your Feedback',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _feedbackController,
                          decoration: const InputDecoration(
                            hintText: 'Write your feedback...',
                            hintStyle: TextStyle(color: Colors.white38),
                          ),
                          maxLines: 3,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addFeedback,
                          child: const Text('Submit Feedback'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                                ///const SizedBox(height: 32),
                const CustomFooter(),
                ],
              
              ),

            ),
          ],
        ),
      );
    }

    Widget _buildFeatureButton(
      BuildContext context,
      String title,
      IconData icon,
      String subtitle,
      VoidCallback onPressed,
    ) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 32, color: Colors.purple),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.purple),
                ],
              ),
            ),
          ),
        ),
      );
    }

    @override
    void dispose() {
      _feedbackController.dispose();
      super.dispose();
    }
  }

  class BackgroundPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()
        ..color = const Color(0xFF4A148C).withOpacity(0)
        ..style = PaintingStyle.fill;

      final path1 = Path()
        ..moveTo(0, size.height * 0.2)
        ..quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.3,
          size.width,
          size.height * 0.2,
        );
      canvas.drawPath(path1, paint);

      final path2 = Path()
        ..moveTo(0, size.height * 0.5)
        ..quadraticBezierTo(
          size.width * 0.7,
          size.height * 0.4,
          size.width,
          size.height * 0.6,
        );
      canvas.drawPath(path2, paint);

      final path3 = Path()
        ..moveTo(0, size.height * 0.8)
        ..quadraticBezierTo(
          size.width * 0.3,
          size.height * 0.7,
          size.width,
          size.height * 0.9,
        );
      canvas.drawPath(path3, paint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  }
