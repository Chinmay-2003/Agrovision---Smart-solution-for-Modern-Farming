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
  
  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Agrovision',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(username: widget.username),
                ),
              ),
              child: Hero(
                tag: 'profile',
                child: CircleAvatar(
                  backgroundColor: Colors.purple[200],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                Colors.purple,
                                Colors.blue,
                                Colors.green,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              widget.username,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(0, 66, 66, 66),
                        ///borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage('assets/images/home.png'), // Use your image path
                          fit: BoxFit.cover, // Adjust the fit
                        ),
                      ),
                    )
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
                const SizedBox(height: 48),
                // Feature Buttons
                ...['Crop Recommendation', 'Fertilizers & Pesticides', 'Government Schemes']
                    .asMap()
                    .entries
                    .map((entry) {
                  final icons = [Icons.grass, Icons.science, Icons.policy];
                  final routes = [
                    const CropRecommendation(),
                    const FertilizersPesticides(),
                    const GovernmentSchemes()
                  ];
                  final descriptions = [
                    'Get AI-powered crop suggestions',
                    'Find the right products for your crops',
                    'Explore available farming schemes'
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
                      options: CarouselOptions(
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
      ..color = const Color(0xFF4A148C).withOpacity(0.15)
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