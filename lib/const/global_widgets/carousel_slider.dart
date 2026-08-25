import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mvvm_consepts/const/global_widgets/custom_gradient_appbar.dart';
import 'package:mvvm_consepts/const/global_widgets/drawer/navigation_drawer.dart';

class UniversalCarouselSlider extends StatelessWidget {
  // 1. Pass images dynamically so it works anywhere
  final List<String> images;

  // 2. Control sizing dynamically via aspect ratio instead of fixed height
  final double aspectRatio;
  final double viewportFraction;

  const UniversalCarouselSlider({
    super.key,
    required this.images,
    this.aspectRatio = 16 / 9, // Default ratio
    this.viewportFraction = 0.8, // Default viewing window
  });

  @override
  Widget build(BuildContext context) {
    // Edge case: Safety check if list is empty
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: CustomGradientAppBar(title: "Album"),
      drawer: NavDrawer(),
      body: CarouselSlider.builder(
        itemCount: images.length,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height-300,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: aspectRatio, // Adapts layout proportionally across screens
          autoPlayInterval: const Duration(seconds: 2),
          viewportFraction: viewportFraction,
        ),
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                images[itemIndex],
                fit: BoxFit.cover, // Forces image to properly fill its dynamic box
              ),
            ),
          );
        },
      ),
    );
  }
}
