import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('blank Page'),
      ),
      body: const Center(
        child: Text('This is the second page!'),
      ),
    );
  }
}
