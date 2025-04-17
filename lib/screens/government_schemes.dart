import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
            const Text(
              'Government Schemes for Farmers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Explore a range of government schemes designed to support farmers. '
              'Tap on any scheme to learn more, visit the official website, or watch a video guide.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          _buildSchemeCard(
            context,
            'PM-KISAN',
            'Income support of ₹6000 per year to farmer families',
            'https://pmkisan.gov.in/',
            'https://youtu.be/jT3f_yDQPnc?si=kLYvVH7psHCMNIz_',
            'The PM-KISAN scheme aims to supplement the financial needs of land-holding farmers...',
          ),
          _buildSchemeCard(
            context,
            'Kisan Credit Card',
            'Provides farmers with timely access to credit',
            'https://sbi.co.in/web/agri-rural/agriculture-banking/crop-loan/kisan-credit-card',
            'https://youtu.be/2mfa7-nfy2o?si=lQq6ORPtz9GeTSF1',
            'The Kisan Credit Card scheme provides farmers with timely access to credit...',
          ),
          _buildSchemeCard(
            context,
            'PM Fasal Bima Yojana',
            'Crop insurance scheme for farmers',
            'https://pmfby.gov.in/',
            'https://youtu.be/c13xywAIMAo?si=P5gcj2-zjC7mmCKF',
            'PMFBY is a crop insurance scheme that provides comprehensive coverage against crop failure...',
          ),
          _buildSchemeCard(
            context,
            'National Mission for Sustainable Agriculture',
            'Promotes sustainable agriculture practices',
            'https://nmsa.dac.gov.in/',
            'https://youtu.be/DS_SMVvqzsg?si=paq7c7BLQWJb_Kgx',
            'NMSA aims to promote sustainable agriculture through climate change adaptation measures...',
          ),
          _buildSchemeCard(
            context,
            'E-NAM',
            'National Agriculture Market',
            'https://www.enam.gov.in/web/',
            'https://youtu.be/oBEFYpnCNLA?si=z37bO4POmD9WjedW',
            'e-NAM is a pan-India electronic trading portal that networks existing APMC mandis...',
          ),
          _buildSchemeCard(
            context,
            'Soil Health Card Scheme',
            'Promotes soil testing based fertilizer usage',
            'https://soilhealth.dac.gov.in/',
            'https://youtu.be/SFKz_aEFfZw?si=_s-P7LbIy9yFhl7B',
            'The Soil Health Card scheme provides information to farmers on nutrient status...',
          ),
          _buildSchemeCard(
            context,
            'PKVY',
            'Paramparagat Krishi Vikas Yojana',
            'https://pgsindia-ncof.gov.in/pkvy/index.aspx',
            'https://youtu.be/6YAKr0rYVzE?si=7BDuoiOJHxJW4AEY',
            'PKVY promotes organic farming through adoption of organic village by cluster approach...',
          ),
          _buildSchemeCard(
            context,
            'Agriculture Infrastructure Fund',
            'Financing facility for agriculture infrastructure',
            'https://agriinfra.dac.gov.in/',
            'https://youtu.be/DwE-Z1ogJwM?si=Gid8ineYT3yiEiFE',
            'The Agriculture Infrastructure Fund provides medium-long term debt financing...',
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
                    onPressed: () async {
                      final uri = Uri.parse(link);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open website')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_circle),
                    label: const Text('Watch Video Guide'),
                    onPressed: () async {
                      final uri = Uri.parse(videoLink);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open video')),
                        );
                      }
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
