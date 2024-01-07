import 'package:flutter/material.dart';

class PageDecoration extends StatelessWidget {
  const PageDecoration({super.key, required this.scaffold});
  final Scaffold scaffold;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        image: const DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage('assets/images/background.jpg'),
        ),
      ),
      child: scaffold,
    );
  }
}
