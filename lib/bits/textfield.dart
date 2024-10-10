import 'package:flutter/material.dart';

class TheTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const TheTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    });
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder:const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 127, 189, 240))
                  ),
                  fillColor: const Color.fromARGB(255, 76, 137, 187),
                  filled: true,
                  hintText: hintText,
                ),
              ),)
          ;
  }
}



