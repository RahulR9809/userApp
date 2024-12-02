import 'package:flutter/material.dart';

// TextFormField with focus and unfocus colors
Widget buildTextField({
  required String hintText,
  required TextEditingController controller,
  Icon? prefixIcon,
  String? Function(String?)? validator, // Added validator as a parameter
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
    validator: validator, // Use the passed validator function
  );
}

// Reusable AuthButton

Widget authbutton(
  BuildContext context,
  String text,
  VoidCallback onPressed, {
  String? imagePath,
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

  const ReusableButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.black,
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

// Reusable Button Widget
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

  // This specifies the preferred height of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
