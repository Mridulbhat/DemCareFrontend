import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/views/intro_screens/screen3_view.dart';
import 'package:flutter/material.dart';

class Screen2View extends StatelessWidget {
  const Screen2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              Navigator.push(
                context,
                _createRoute(), // Slide left to navigate to the next page
              );
            }
            if (details.primaryVelocity! > 0) {
              Navigator.pop(context); // Pop the current page
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/Lifesavers_Caretaking.png',
                      width: 350,
                      height: 343,
                    ),

                    const SizedBox(height: 35),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: Colors.grey,
                        ),
                      ],
                    ),

                    // Main text
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                      child: Text(
                        'Medication and Health Reminders',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF432C81),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Subtitle text
                    const Text(
                      'Receive reminders for medications and appointments to stay on top of your health.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF82799D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // Skip tour button at the bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteConstants.landingViewRoute);
                    },
                    child: const Text(
                      'Skip Tour',
                      style: TextStyle(fontSize: 14, color: Color(0xFF82799D)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Screen3View(), // Pass the parameter to SecondPage
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right
        const end = Offset.zero; // End at the center
        const curve = Curves.easeInOut; // Smooth transition curve

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
