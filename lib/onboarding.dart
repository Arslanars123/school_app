
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/onboarding_screen_one.dart';
import 'package:school_app/onboarding_screen_two.dart';
import 'package:school_app/onboarding_three_screen.dart';
import 'package:school_app/roles_screen.dart';
import 'package:school_app/splash_screen.dart';

class OnboardingScreensDots extends StatefulWidget {
  static Widget builder(BuildContext context) {
    return OnboardingScreensDots();
  }

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreensDots> with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  final PageController _controller = PageController();
  final int _numPages = 4; // Set the number of onboarding screens here
  var _currentPage = 0;
  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);
    super.initState();
  }
  static String imgReplicatePredi = 'assets/images/img_replicate_predi.png';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3E4648
        ),
        body: Stack(
          children: [
            Container(


              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [


                  Stack(
                    children: [

                      _currentPage != 0 ?      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(

                            height: MediaQuery.of(context).size.height/8,
                            width: MediaQuery.of(context).size.width/8,
                            decoration: BoxDecoration(

                              image: DecorationImage(image: AssetImage( imgReplicatePredi,),
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):SizedBox(),

                      _currentPage != 0 ?  Center(
                        child: Padding(
                          padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
                          child: Text(
                            "Unlock Your Potential",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Color(0xFFCBAC78), fontSize: 17,fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ):SizedBox(),
                    ],
                  ),
                  SizedBox(width: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        SplashScreen(),
                        OnBoardingOne(),
                        OnBoardingTwo(),
                        OnBoardingThree()

                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height/15,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  DotsIndicator(
                    dotsCount: _numPages,
                    position: _currentPage,
                    decorator: DotsDecorator(
                      color: Colors.grey,
                      // Inactive dot color
                      activeColor: Colors.white,
                      spacing: EdgeInsets.all(5.0),
                      size: const Size.square(8.0),
                      activeSize: const Size(20.0, 8.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),


                  SizedBox(height: MediaQuery.of(context).size.height/20,),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RolesScreen()),
                        );
                      },
                      child: Text("Skip",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),))

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


