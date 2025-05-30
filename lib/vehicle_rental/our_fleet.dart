import 'package:flutter/material.dart';

class OurFleetPage extends StatelessWidget {
  const OurFleetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Fleet'),
        backgroundColor: Colors.blue, // Match theme color
      ),
      body: Center(
        child: Text(
          'Welcome to Our Fleet!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.redAccent, // Black shadow for glow effect
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
