import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obsecureText;
  const MyTextField(
      {super.key,
      required this.name,
      required this.controller,
      required this.hintText,
      required this.icon,
      required this.keyboardType,
      this.obsecureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: TextFormField(
          obscureText: obsecureText,
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
              // labelText: name,
              // labelStyle: const TextStyle(
              //     color: Colors.red, fontWeight: FontWeight.bold),
              prefixIcon: icon != null ? Icon(icon) : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffDB4437)),
                  borderRadius: BorderRadius.circular(12)),
              hintText: hintText,
              hintStyle: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.headlineMedium,
                fontSize: 15,
                color: Colors.black54,
                //fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal,
              ),
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              fillColor: Colors.grey[200]),
          validator: (value) {
            if (value!.isEmpty) {
              return hintText;
            }
            return null;
          },
        ),
      ),
    );
  }
}
