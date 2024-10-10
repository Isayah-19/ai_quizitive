import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const SquareTile({super.key, required this.imagePath, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 146, 187, 220)),
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 106, 166, 215)
        ),
        child: Image.asset(imagePath, height: 40,),
      ),
    );
  }
}