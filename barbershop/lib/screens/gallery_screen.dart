import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/gallery_item.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/gallery_card.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final galleryItems = [
      GalleryItem(
        id: '1',
        title: 'Classic Gentleman',
        description:
            'Timeless style with side part and tapered sides. Perfect for formal occasions.',
        imageUrl: 'assets/images/4.jpg',
      ),
      GalleryItem(
        id: '2',
        title: 'Modern Fade',
        description:
            'Sleek fade with textured top. Our most requested style for a sharp, clean look.',
        imageUrl: 'assets/images/5.jpg',
      ),
      GalleryItem(
        id: '3',
        title: 'Beard Trim & Shape',
        description:
            'Professional beard grooming to maintain your facial hair in perfect shape.',
        imageUrl: 'assets/images/8.jpg',
      ),
      GalleryItem(
        id: '4',
        title: 'Kids Cut',
        description:
            'Specialized cuts for young gentlemen, making haircuts a fun experience.',
        imageUrl: 'assets/images/7.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.lightColor,
      appBar: const CustomAppBar(title: 'Gallery', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Our Work Gallery',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Browse through our collection of signature styles and transformations',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textColor.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children:
                    galleryItems
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GalleryCard(item: item),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
