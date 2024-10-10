import 'package:flutter/material.dart';
class SigninButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  
  const SigninButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
    onTap: onTap,
     child: Container(
        padding: const EdgeInsets.all(15),  // Reduced padding to make the button smaller
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),  // Added rounded corners with a radius of 12
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),

   );
  }
}