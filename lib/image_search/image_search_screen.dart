import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageSearchScreen extends StatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  List imageLinks =['https://cdn.pixabay.com/photo/2012/03/01/00/55/flowers-19830_640.jpg',
                    'https://cdn.pixabay.com/photo/2012/03/01/00/55/flowers-19830_640.jpg',
                    // 'https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg'
                    ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateAccuracy();
  }
  void calculateAccuracy() {
    // Load your set of image links for comparison
    // Replace this with your own image links
    int totalPairs = 0;
    setState(() {
      totalPairs = imageLinks.length;
    });
    int correctMatches = 0;

    for (int i = 0; i < totalPairs; i++) {
      setState(() {
        bool isMatch = compareImages(imageLinks[i]);
        if (isMatch) {
        correctMatches++;
      }
      });

      // If your visual inspection matches your comparison, consider it correct
      
    }

    

    setState(() {
      double accuracy = correctMatches / totalPairs;
    print('Accuracy: $accuracy');
    });
  }

  bool compareImages(List<String> imagePair) {
    // Load and preprocess the images
    img.Image? image1 = img.decodeImage(imagePair[0] as Uint8List);
    img.Image? image2 = img.decodeImage(imagePair[1] as Uint8List);

    // Calculate a similarity metric (e.g., Mean Squared Error)
    double similarity = calculateSimilarity(image1!, image2!);

    // Define a threshold for similarity
    double similarityThreshold = 100.0;

    // Compare with the threshold and return true if similar
    return similarity < similarityThreshold;
  }

  double calculateSimilarity(img.Image image1, img.Image image2) {
    // Implement a similarity metric (e.g., Mean Squared Error)
    double mse = img.meanSquaredError(image1, image2);
    return mse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: ListView.builder(
        itemCount: imageLinks.length,
        itemBuilder: (ctx,index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(imageLinks[index]),
        );
      }),
    );
  }
}
