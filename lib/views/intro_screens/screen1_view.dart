import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/intro_screens/screen2_view.dart';
import 'package:flutter/material.dart';

class Screen1View extends StatelessWidget {
  const Screen1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            Navigator.push(
              context,
              _createRoute(), // Slide left to navigate to the next page
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/Lifesavers_Hand.png',
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
                            backgroundColor: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.grey,
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
                        'Support for Caregivers',
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
                      'Caregivers can monitor and assist with tasks, ensuring peace of mind.',
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
                    onPressed: () async {
                      await SharedPrefs().getAllValues().then((value) => {
                            if (value['token'] == '')
                              {
                                Navigator.pushNamed(
                                    context, RouteConstants.landingViewRoute)
                              }
                            else if (value['isUserNew'] == 'true')
                              {
                                Navigator.pushNamed(context,
                                    RouteConstants.emergencyContactsViewRoute)
                              }
                            else
                              {
                                Navigator.pushNamed(
                                    context, RouteConstants.mainViewRoute)
                              }
                          });
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
          const Screen2View(), // Pass the parameter to SecondPage
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
