import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // Text controller for taking rollno
  final TextEditingController rollnoController = TextEditingController();
  String? errorMessage;
  String? imageUrl;

  // Get data from the link
  Future<void> searchData() async {
    String rollno = rollnoController.text.toUpperCase();

    if (rollno.isEmpty) {
      setState(() {
        errorMessage = "Please enter a Roll Number.";
        imageUrl = null;
      });
      return;
    }

    final url =
        Uri.parse('https://info.aec.edu.in/ACET/StudentPhotos/$rollno.jpg');

    try {
      final response = await http.head(url);

      if (response.statusCode == 200) {
        setState(() {
          imageUrl = url.toString(); // Set the image URL if found
          errorMessage = null; // Clear error message
        });
      } else {
        setState(() {
          imageUrl = null; // Clear image URL if not found
          errorMessage = "Image not found for Roll Number: $rollno";
        });
      }
    } catch (e) {
      setState(() {
        imageUrl = null; // Clear image URL in case of error
        errorMessage = "Error fetching image: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Fetcher'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: rollnoController,
                decoration: InputDecoration(
                  hintText: 'Enter Roll Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: EdgeInsets.only(top: 0, right: 20, bottom: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Clear button
                  MaterialButton(
                    onPressed: () {
                      rollnoController.clear();
                      setState(() {
                        errorMessage = null;
                        imageUrl = null;
                      });
                    },
                    child: Text('Clear'),
                  ),

                  // Search button
                  MaterialButton(
                    color: Colors.grey[600],
                    onPressed: searchData, // Call searchData when pressed
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Display error message
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            // Display image if found
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.network(
                  imageUrl!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('Failed to load image'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
