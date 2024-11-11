import 'package:devcare_frontend/res/colors.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed; // Function parameter for onPressed
  final String buttonText; // Text parameter for the button label

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Use the passed onPressed function
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Border radius of 8
            side: const BorderSide(
              color: AppColors.primaryColor, // Border color same as primary color
              width: 1.0, // Width of the border
            ),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(double.infinity, 48), // Max width, custom height (48)
        ),
        padding: MaterialStateProperty.all(EdgeInsets.zero), // Exact size control
      ),
      child: Text(
        buttonText, // Use the passed button text
        style: const TextStyle(color: AppColors.primaryColor, fontSize: 16),
      ),
    );
  }
}
