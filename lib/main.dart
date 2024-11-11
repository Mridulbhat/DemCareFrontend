import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/home_screens/home_view.dart';
import 'package:devcare_frontend/views/home_screens/home_viewmodel.dart';
import 'package:devcare_frontend/views/intro_screens/screen1_view.dart';
import 'package:devcare_frontend/views/intro_screens/screen2_view.dart';
import 'package:devcare_frontend/views/intro_screens/screen3_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/landing_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/login_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/otp_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_viewmodel.dart';
import 'package:devcare_frontend/views/onboarding_screens/updateContacts_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SharedPrefs()),
        ChangeNotifierProvider(create: (context) => SignupViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: RouteConstants.introScreen1Route,
      routes: {
        RouteConstants.introScreen1Route: (context) => Screen1View(),
        RouteConstants.introScreen2Route: (context) => Screen2View(),
        RouteConstants.introScreen3Route: (context) => Screen3View(),

        RouteConstants.landingViewRoute: (context) => LandingView(),
        RouteConstants.signupViewRoute: (context) => SignupView(),
        RouteConstants.loginViewRoute: (context) => LoginView(),
        RouteConstants.otpViewRoute: (context) => OtpView(),
        RouteConstants.emergencyContactsViewRoute: (context) => UpdateContactsView(),

        RouteConstants.homeViewRoute: (context) => HomeView(),
      },
    );
  }
}
