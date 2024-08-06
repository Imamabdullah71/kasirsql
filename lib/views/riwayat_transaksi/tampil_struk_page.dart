import 'package:flutter/material.dart';

class TampilStrukPage extends StatelessWidget {
  final String gambarStruk;

  TampilStrukPage({super.key, required this.gambarStruk});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = 'http://10.10.10.129/flutterapi/struk/$gambarStruk';

    print('Attempting to load image from URL: $imageUrl');

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 114, 94, 225),
          ),
          title: const Text(
            "Struk",
            style: TextStyle(
              color: Color.fromARGB(255, 114, 94, 225),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 10.0, // Add this line to set the shadow
          shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.purple),
                      strokeWidth: 5.0,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      semanticsLabel: 'Loading image',
                      semanticsValue: loadingProgress.expectedTotalBytes != null
                          ? '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%'
                          : 'Loading...',
                      strokeCap: StrokeCap.round,
                    ),
                  );
                }
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                print('Failed to load image: $error');
                return const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ));
  }
}
