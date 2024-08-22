
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();

  static Widget builder(BuildContext context) {
    return SplashScreen();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the main screen after a delay
   Future.delayed(
      Duration(seconds: 2), // Adjust the duration as needed
          () {
       /* Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreensDots.builder(context), // Replace with your main screen widget
          ),
        );*/
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3E4648),
      body: Center(
        child: Image.asset("assets/images/Group 7369.png",scale: 2,),
      ),
    );
  }
}
