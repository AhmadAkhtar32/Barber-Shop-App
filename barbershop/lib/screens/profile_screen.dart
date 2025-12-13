import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightColor,
      appBar: const CustomAppBar(title: 'My Profile', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('assets/images/profile.jpg'),
              backgroundColor: AppColors.secondaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Ahsan Abdullah',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'CEO',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileItem(Icons.email, 'HILULU@gamil.com'),
            _buildProfileItem(Icons.phone, '+1 (555) 123-4567'),
            _buildProfileItem(Icons.calendar_today, 'Member since: June 2024'),
            _buildProfileItem(Icons.location_on, '123 Main St, Okara'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLightColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentColor, size: 28),
          const SizedBox(width: 16),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
