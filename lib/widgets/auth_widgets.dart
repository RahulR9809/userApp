import 'package:flutter/material.dart';

Widget buildTextField({
  required String hintText,
  required TextEditingController controller,
  Icon? prefixIcon,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    style: const TextStyle(color: Colors.black),
    validator: validator, 
  );
}


Widget authbutton(
  BuildContext context,
  String text,
  VoidCallback onPressed, {
  String? imagePath, required Color buttonColor, required Color textColor, required borderColor,
}) {
  final size = MediaQuery.of(context).size;
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.1,
        vertical: 18,
      ),
      minimumSize: const Size(double.infinity, 50),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min, 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imagePath != null) 
          Padding(
            padding: const EdgeInsets.only(
                right: 8.0),
            child: Image.asset(
              imagePath,
              width: 24, 
              height: 24,
            ),
          ),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

class ReusableButton extends StatelessWidget {
  final String text; 
  final VoidCallback onPressed; 
  final Color color;
  const ReusableButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: color,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomTextButton(
      {required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 18,
        ),
      ),
    );
  }
}

class ElectraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ElectraAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF003366), // Deep navy color
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
