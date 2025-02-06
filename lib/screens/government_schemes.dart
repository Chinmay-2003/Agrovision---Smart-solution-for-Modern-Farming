import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_app_bar.dart';

class GovernmentSchemes extends StatelessWidget {
  const GovernmentSchemes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Government Schemes'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSchemeCard(
            context,
            'PM-KISAN',
            'Income support of ₹6000 per year to farmer families',
            'https://pmkisan.gov.in/',
            'https://youtu.be/example1',
            'The PM-KISAN scheme aims to supplement the financial needs of land-holding farmers. The scheme provides income support of ₹6000 per year in three equal installments. The amount is directly transferred to the bank accounts of eligible farmer families.',
          ),
          _buildSchemeCard(
            context,
            'Kisan Credit Card',
            'Provides farmers with timely access to credit',
            'https://www.nabard.org/content1.aspx?id=1720&catid=23&mid=23',
            'https://youtu.be/example2',
            'The Kisan Credit Card scheme provides farmers with timely access to credit. Farmers can use this credit for their agricultural needs, including purchase of inputs like seeds, fertilizers, etc.',
          ),
          _buildSchemeCard(
            context,
            'PM Fasal Bima Yojana',
            'Crop insurance scheme for farmers',
            'https://pmfby.gov.in/',
            'https://youtu.be/example3',
            'PMFBY is a crop insurance scheme that provides comprehensive coverage against crop failure, helping farmers stabilize their income and ensure credit worthiness.',
          ),
          _buildSchemeCard(
            context,
            'National Mission for Sustainable Agriculture',
            'Promotes sustainable agriculture practices',
            'https://nmsa.gov.in/',
            'https://youtu.be/example4',
            'NMSA aims to promote sustainable agriculture through climate change adaptation measures, water use efficiency, soil health management, and synergizing resource conservation.',
          ),
          _buildSchemeCard(
            context,
            'E-NAM',
            'National Agriculture Market',
            'https://enam.gov.in/',
            'https://youtu.be/example5',
            'e-NAM is a pan-India electronic trading portal that networks existing APMC mandis to create a unified national market for agricultural commodities.',
          ),
          _buildSchemeCard(
            context,
            'Soil Health Card Scheme',
            'Promotes soil testing based fertilizer usage',
            'https://soilhealth.dac.gov.in/',
            'https://youtu.be/example6',
            'The Soil Health Card scheme provides information to farmers on nutrient status of their soil along with recommendations on appropriate dosage of nutrients for improving soil health and fertility.',
          ),
          _buildSchemeCard(
            context,
            'PKVY',
            'Paramparagat Krishi Vikas Yojana',
            'https://pgsindia-ncof.gov.in/',
            'https://youtu.be/example7',
            'PKVY promotes organic farming through adoption of organic village by cluster approach and PGS certification.',
          ),
          _buildSchemeCard(
            context,
            'Agriculture Infrastructure Fund',
            'Financing facility for agriculture infrastructure',
            'https://agriinfra.dac.gov.in/',
            'https://youtu.be/example8',
            'The Agriculture Infrastructure Fund provides medium-long term debt financing for investment in viable projects for post-harvest management infrastructure.',
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(
    BuildContext context,
    String title,
    String description,
    String link,
    String videoLink,
    String fullDescription,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          onTap: () => _showSchemeDetails(
            context,
            title,
            fullDescription,
            link,
            videoLink,
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Learn More'),
                      onPressed: () => _showSchemeDetails(
                        context,
                        title,
                        fullDescription,
                        link,
                        videoLink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSchemeDetails(
    BuildContext context,
    String title,
    String description,
    String link,
    String videoLink,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.link),
                    label: const Text('Visit Official Website'),
                    onPressed: () {
                      // Implement URL launcher
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_circle),
                    label: const Text('Watch Video Guide'),
                    onPressed: () {
                      // Implement video launcher
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}