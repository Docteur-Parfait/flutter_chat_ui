import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GlobalNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? imageWidth;
  final double? imageHeight;

  const GlobalNetworkImage(
      {super.key, required this.imageUrl, this.imageWidth, this.imageHeight});

  @override
  Widget build(BuildContext context) {
    // Obtenir la largeur de l'écran
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculer la largeur maximale (75% de la largeur de l'écran)
    final maxWidth = screenWidth * 0.70;

    // Calculer le ratio de l'image
    final ratio = (imageWidth ?? 1) / (imageHeight ?? 1);

    // Calculer les dimensions de l'image avec la contrainte de hauteur maximale de 400 pixels
    double imageDisplayWidth;
    double imageDisplayHeight;

    if ((maxWidth / ratio) > 250) {
      imageDisplayHeight = 250;
      imageDisplayWidth = 250 * ratio;
    } else {
      imageDisplayWidth = maxWidth;
      imageDisplayHeight = maxWidth / ratio;
    }
    return GestureDetector(
      child: Container(
        width: imageDisplayWidth,
        height: imageDisplayHeight,
        alignment: Alignment.center,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              final progress = downloadProgress.progress == null
                  ? 0.0
                  : double.parse(
                      (downloadProgress.progress!).toStringAsFixed(2));

              log('Loading : $progress');
              final percent = progress.toInt() * 100;
              return CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 2.0,
                percent: progress,
                center: Text('$percent%', style: const TextStyle(fontSize: 14)),
                progressColor: Colors.green,
              );
            },
            // placeholder: (context, url) => Blur(
            //   child: Image.asset(
            //     'assets/blur.jpg',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
