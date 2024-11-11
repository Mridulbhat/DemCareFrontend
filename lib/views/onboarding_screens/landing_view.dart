import 'package:devcare_frontend/res/primaryButton.dart';
import 'package:devcare_frontend/res/secondaryButton.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:flutter/material.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF432C81),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'DemCare',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF432C81),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Image.asset(
                  'assets/images/landing.png',
                  height: 390,
                ),
                const SizedBox(height: 46),
                PrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteConstants.signupViewRoute);
                  },
                  buttonText: 'Sign Up',
                ),
                const SizedBox(height: 16),
                SecondaryButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteConstants.loginViewRoute);
                  },
                  buttonText: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
