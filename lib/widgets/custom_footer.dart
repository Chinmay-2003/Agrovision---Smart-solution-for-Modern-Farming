import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.purple.withOpacity(0.2),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterItem(Icons.email, 'Contact Us'),
              _buildFooterItem(Icons.help, 'Help Center'),
              _buildFooterItem(Icons.info, 'About Us'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2025 Agrovision. All rights reserved.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.purple[200], size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.purple[200],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}