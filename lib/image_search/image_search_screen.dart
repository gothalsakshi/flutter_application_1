
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ImageSimilarityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Similarity'),
        ),
        body: Center(
          child: ImageSimilarityWidget(),
        ),
      ),
    );
  }
}

class ImageSimilarityWidget extends StatefulWidget {
  @override
  _ImageSimilarityWidgetState createState() => _ImageSimilarityWidgetState();
}

class _ImageSimilarityWidgetState extends State<ImageSimilarityWidget> {
  double similarity = 0.0;

  @override
  void initState() {
    super.initState();
    calculateSimilarity();
  }

  void calculateSimilarity() async {
    try {
      Uint8List imageBytes1 = await loadImageBytes('assets/image1.jpg');
      Uint8List imageBytes2 = await loadImageBytes('assets/image2.jpg');

      img.Image image1 = img.decodeImage(imageBytes1)!;
      img.Image image2 = img.decodeImage(imageBytes2)!;

      double mseSimilarity = calculateMSESimilarity(image1, image2);

      setState(() {
        similarity = mseSimilarity;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  double calculateMSESimilarity(img.Image image1, img.Image image2) {
    double sumSquaredDifferences = 0;

    for (int y = 0; y < image1.height; y++) {
      for (int x = 0; x < image1.width; x++) {
        int pixel1 = image1.getPixel(x, y);
        int pixel2 = image2.getPixel(x, y);
        int diff = (pixel1 - pixel2);
        setState(() {
          sumSquaredDifferences += diff * diff;
        });
      }
    }

    double mse = sumSquaredDifferences / (image1.width * image1.height);
    double similarity = 1 - mse; // Normalize to similarity (higher value is more similar)
    return similarity;
  }

  Future<Uint8List> loadImageBytes(String imagePath) async {
    File imageFile = File(imagePath);
    debugPrint('checking--->${imagePath}--->${imageFile.toString()}');
    if ( imageFile.existsSync()) {
      return imageFile.readAsBytes();
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/image1.jpg'),
        Text(
          'Similarity: ${(similarity * 100).toStringAsFixed(2)}%',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}