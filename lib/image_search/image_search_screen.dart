
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class ImageSimilarityWidget extends StatefulWidget {
  const ImageSimilarityWidget({super.key});

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

    ByteData byteData = await rootBundle.load('assets/image2.jpg');

    Uint8List bytes = byteData.buffer.asUint8List();

    ByteData byteData2 = await rootBundle.load('assets/image1.jpg');

    Uint8List bytes2 = byteData2.buffer.asUint8List();
    // Load the two images
    img.Image? image1 = img.decodeImage(Uint8List.fromList(bytes));
    img.Image? image2 = img.decodeImage(Uint8List.fromList(bytes2));

    // Calculate the Structural Similarity Index (SSI)
    double ssi = calculateSSI(image1!, image2!);

    setState(() {
      similarity = ssi;
    });
  }

  double calculateSSI(img.Image image1, img.Image image2) {
    // Calculate the Structural Similarity Index (SSI)
    // Using a simplified example, this may not be accurate for all cases
    double sum = 0.0;

    for (int y = 0; y < image1.height; y++) {
      for (int x = 0; x < image1.width; x++) {
        int pixel1 = image1.getPixel(x, y);
        int pixel2 = image2.getPixel(x, y);
        sum += (pixel1 - pixel2).abs();
      }
    }
    return 1 - (sum / (image1.width * image1.height));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Similarity: ${(similarity * 100).toStringAsFixed(2)}%',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    ),
    );
  }
}