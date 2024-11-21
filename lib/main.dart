import 'package:devcare_frontend/views/home_screens/game_view.dart';
import 'package:devcare_frontend/views/home_screens/videoplay_view.dart';
import 'package:devcare_frontend/views/home_screens/videos_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import your view models and screens
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/home_screens/games_view.dart';
import 'package:devcare_frontend/views/home_screens/home_view.dart';
import 'package:devcare_frontend/views/home_screens/main_view.dart';
import 'package:devcare_frontend/views/intro_screens/screen1_view.dart';
import 'package:devcare_frontend/views/intro_screens/screen2_view.dart';
import 'package:devcare_frontend/views/intro_screens/screen3_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/landing_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/login_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/otp_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_view.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_viewmodel.dart';
import 'package:devcare_frontend/views/onboarding_screens/updateContacts_view.dart';
import 'package:devcare_frontend/views/home_screens/home_viewmodel.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: RouteConstants.introScreen1Route,
      onGenerateRoute: (settings) {
        if (settings.name == RouteConstants.introScreen1Route) {
          return MaterialPageRoute(builder: (context) => Screen1View());
        } else if (settings.name == RouteConstants.introScreen2Route) {
          return MaterialPageRoute(builder: (context) => Screen2View());
        } else if (settings.name == RouteConstants.introScreen3Route) {
          return MaterialPageRoute(builder: (context) => Screen3View());
        } else if (settings.name == RouteConstants.landingViewRoute) {
          return MaterialPageRoute(builder: (context) => LandingView());
        } else if (settings.name == RouteConstants.signupViewRoute) {
          return MaterialPageRoute(builder: (context) => SignupView());
        } else if (settings.name == RouteConstants.loginViewRoute) {
          return MaterialPageRoute(builder: (context) => LoginView());
        } else if (settings.name == RouteConstants.otpViewRoute) {
          return MaterialPageRoute(builder: (context) => OtpView());
        } else if (settings.name == RouteConstants.emergencyContactsViewRoute) {
          return MaterialPageRoute(builder: (context) => UpdateContactsView());
        } else if (settings.name == RouteConstants.mainViewRoute) {
          return MaterialPageRoute(builder: (context) => MainView());
        } else if (settings.name == RouteConstants.allGameViewRoute) {
          return MaterialPageRoute(builder: (context) => GamesView());
        } else if (settings.name == RouteConstants.homeViewRoute) {
          return MaterialPageRoute(builder: (context) => HomeView());
        } else if (settings.name == RouteConstants.gameViewRoute) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => GameViewScreen(url: args['url']),
          );
        } else if (settings.name == RouteConstants.videosViewRoute) {
          return MaterialPageRoute(builder: (context) => VideosView());
        } else if (settings.name == RouteConstants.videoPlayRoute) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => VideoPlayView(url: args['url']),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text('Route not found')),
            ),
          );
        }
      },
    );
  }
}
