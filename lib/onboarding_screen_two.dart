import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingTwo extends StatefulWidget {
  @override
  State<OnBoardingTwo> createState() => _ONBoardingTwoState();
}

class _ONBoardingTwoState extends State<OnBoardingTwo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3E4648),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          AssetImage("assets/images/LogoOnboarding (2).png"))),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            _buildFortyFourSection(context),
          ],
        ),
      ),
    );
  }
}

/// Section Widget
Widget _buildFortyFourSection(BuildContext context) {
  return Align(
    alignment: Alignment.centerRight,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text("Vision",
                style: GoogleFonts.barlow(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: Color(0xffCBAC78))),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 70),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Center(
              child: Text(
"To revolutionize the learning experiences which increase the learning",                  // "Our app provides immediate feedback to teachers and parents including class attendance and assessment results.",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.6))
                  // style: theme.textTheme.bodyLarge!.copyWith(
                  //   height: 1.2,
                  // ),
                  ),
            ),
          ),
        ),

        /* Container(
            height: 7.v,
            margin: EdgeInsets.only(left: 118.h),
            child: AnimatedSmoothIndicator(
              activeIndex: 0,
              count: 3,
              effect: ScrollingDotsEffect(
                spacing: 7,
                activeDotColor:
                    theme.colorScheme.onPrimaryContainer.withOpacity(1),
                dotColor: appTheme.gray20002.withOpacity(0.42),
                dotHeight: 7.v,
                dotWidth: 7.h,
              ),
            ),
          ),*/
      ],
    ),
  );
}

/// Section Widget
