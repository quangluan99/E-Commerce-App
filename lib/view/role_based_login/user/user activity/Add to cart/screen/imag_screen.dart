import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/author_post/image5.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.white12,
          ),
        ],
      ),
    );
  }
}
