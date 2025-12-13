import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightColor,
      appBar: const CustomAppBar(title: 'Our Services', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Featured Service
            _buildServiceCard(
              'assets/images/9.jpg',
              'Premium Haircut',
              'Signature haircut with hot towel treatment and styling',
              '60 min • \$45',
            ),

            // Service List
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildServiceItem('Classic Cut', '25', Icons.cut),
                  _buildServiceItem('Beard Trim', '18', Icons.content_cut),
                  _buildServiceItem('Hair Color', '65', Icons.color_lens),
                  _buildServiceItem(
                    'Hot Shave',
                    '35',
                    Icons.fireplace,
                  ), // Changed from Icons.heat
                  _buildServiceItem('Kids Cut', '20', Icons.child_care),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildServiceCard(
    String image,
    String title,
    String desc,
    String price,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 200,
                    color: AppColors.secondaryColor,
                    child: const Icon(Icons.image, size: 50),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(desc, style: GoogleFonts.poppins(fontSize: 16)),
                const SizedBox(height: 16),
                Text(
                  price,
                  style: GoogleFonts.poppins(color: AppColors.accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String name, String price, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accentColor),
      title: Text(
        name,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      trailing: Text('\$$price', style: GoogleFonts.poppins()),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
