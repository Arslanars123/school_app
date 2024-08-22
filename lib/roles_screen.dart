import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_app/institute_login_screen.dart';
import 'package:school_app/login_student_screen.dart';
import 'package:school_app/parent_login_screen.dart';
import 'package:school_app/teacher_login_screen.dart';
import 'package:google_fonts/google_fonts.dart';



class RolesScreen extends StatelessWidget {


  List quickMenuTitle = [
    'Student',
    'Teacher',
    'Parent',
    'Institute',
  ];
  List quickMenuImage = [
    'assets/students.png',
    'assets/teachers.png',
    'assets/parents.png',
    'assets/classes.png',
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 1;
    var width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
        backgroundColor: const Color(0xff3E4648),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height/13),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff3E4648),
            title:   Container(

              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),

                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/bg.png'))),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset("assets/images/Frame 7394.png")),
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Stack(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Container(
                  color: Colors.white,
                width: width,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.020,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.03,
                            ),

                            Text(
                              'What Is Your Role?',
                              style: GoogleFonts.barlow(
                                fontSize: 28, // Font size
                                fontWeight: FontWeight.w700, // Font weight
                                height: 1.2, // Line height equivalent
                                letterSpacing: -1, // Letter spacing
                              ),),
                          ],
                        ),
                        SizedBox(
                          height: height/100,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Text(
                              'Choose your user type to get started.',
                              style: GoogleFonts.barlow(
                                color:Color(0xFF8A8A8E),
                                fontSize: 15, // Font size
                                fontWeight: FontWeight.w400, // Font weight
                                height: 1.2, // Line height equivalent
                                letterSpacing: -1, // Letter spacing
                              ),),
                          ],
                        ),

                        SizedBox(
                          height: height * 0.16,
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2, // Set the number of columns
                          children: List.generate(4, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.025,
                                  right: width * 0.025,
                                  bottom: height * 0.025),
                              child: InkWell(
                                onTap: (){
                                  if (quickMenuTitle[index]== "Teacher") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  LoginOneScreen()),
                                    );
                                  }
                                  if (quickMenuTitle[index] == "Student") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  StudentLoginScreen()),
                                    );
                                  }
                                  if (quickMenuTitle[index] == "Parent") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ParentLoginScreen()),
                                    );
                                  }
                                  if (quickMenuTitle[index]== "Institute") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InstituteLoginScreen()));
                                  }
                                },
                                child: Container(
                                  width: width * 0.35,
                                  height: height * 0.35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image(
                                        height: 65,
                                        fit: BoxFit.fitWidth,
                                        image: AssetImage(
                                          quickMenuImage[index],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Text(
                                        quickMenuTitle[index],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xff3C3C43),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        )

                        ,
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ],
        ));
  }
}
