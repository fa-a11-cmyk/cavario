import 'package:flutter/material.dart';

class AppImages {
  static const String logo = 'assets/images/logo.png';
  static const String horse1 = 'assets/images/horse1.jpg';
  static const String horse2 = 'assets/images/horse2.jpg';
  static const String stable = 'assets/images/stable.jpg';
  static const String riding = 'assets/images/riding.jpg';
  static const String competition = 'assets/images/competition.jpg';
}

class ImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? fallback;

  const ImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        );
      },
    );
  }
}