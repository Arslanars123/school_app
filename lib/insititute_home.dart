import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_app/classes.dart';
import 'package:school_app/classes_for_students.dart';
import 'package:school_app/institute_login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/parents.dart';
import 'package:school_app/students_list_screen.dart';
import 'package:school_app/teachers.dart';
class InsitituteHomeScreen extends StatefulWidget {
  const InsitituteHomeScreen({super.key});

  @override
  State<InsitituteHomeScreen> createState() => _InsitituteHomeScreenState();
}

class _InsitituteHomeScreenState extends State<InsitituteHomeScreen> {
  List quickMenuTitle = [
    'Students',
    'Teachers',
    'Parents',
    'Classes',
    'Attendance',
    'Sales',
  ];
  List quickMenuImage = [
    'assets/students.png',
    'assets/teachers.png',
    'assets/parents.png',
    'assets/classes.png',
    'assets/attendance.png',
    'assets/sales.png',
  ];

  var quickMenuContainerColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF3E4648),

      body: SafeArea(
        child: Column(
          children: [
            Container(

              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),

                /*  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/bg.png'))*/),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/images/Frame 7394.png"),
                        CircleAvatarWithNetworkImage(
                          imageUrl:"http://170.249.216.178/~filterba/schooling/public/"+schoolImage.toString(), // Replace with your image URL
                          placeholder: AssetImage('assets/images/no_image.jpg'), // Replace with your placeholder image asset
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 10,right: 10),
              child: Align(
                alignment: Alignment.topLeft,


                child: Text(
                  'Good Morning, Alex',
                  style: GoogleFonts.barlow(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 10,right: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'How would you like to start today?',
                  style: GoogleFonts.barlow(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: height/20,),


            Expanded(child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              ),
              child:  Column(
                children: [
              Padding(
              padding:  EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Quick Menu',
                  style: GoogleFonts.barlow(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),


                            shrinkWrap: true,

                            itemCount: 6,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return
                                InkWell(
                                  onTap: (){
                                    if (quickMenuTitle[index]== "Students") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ClassesForStudents(),
                                        ),
                                      );
                                    }
                                    if (quickMenuTitle[index] == "Teachers") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TeachersList(),
                                        ),
                                      );
                                    }
                                    if (quickMenuTitle[index] == "Parents") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ParentsListScreen(),
                                        ),
                                      );
                                    }
                                    if (quickMenuTitle[index]== "Classes") {
                                           Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClassesListScreen (),
                                                ),
                                              );
                                    }
                                    if (quickMenuTitle[index]== "Attendance") {
                                      /*  Navigator.push(
                                                context,*/
                                      /*        MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeHeadmasterOnePage.builder(context),
                                                ),*/
                                      /*   );*/
                                    }
                                    if (quickMenuTitle[index]== "Sales") {
                                      /*   Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeHeadmasterPage.builder(context),
                                                ),
                                              );*/
                                    }

                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.025,
                                        right: width * 0.025,
                                        bottom: height * 0.025),
                                    child: Container(
                                      width: width * 0.35,
                                      height: height * 0.35,
                                      decoration: BoxDecoration(
                                        color: quickMenuContainerColors[index].withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image(
                                            height: height/12,
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
                            },
                          ),

                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ))

          ],
        ),
      ),
    );
  }
}
class CircleAvatarWithNetworkImage extends StatelessWidget {
  final String imageUrl;
  final ImageProvider placeholder;

  const CircleAvatarWithNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.blue, // Set your desired background color
      child: ClipOval(
        child: FadeInImage(
          placeholder: placeholder,
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          fadeInDuration: Duration(milliseconds: 300),
          fadeOutDuration: Duration(milliseconds: 300),
          imageErrorBuilder: (context, error, stackTrace) {
            // Display placeholder when image fails to load
            return Image(image: placeholder);
          },
        ),
      ),
    );
  }
}