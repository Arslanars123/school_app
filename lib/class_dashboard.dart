import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_app/institute_login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/parents.dart';
import 'package:school_app/students_list_screen.dart';
import 'package:school_app/teacher_classes.dart';
import 'package:school_app/teachers.dart';
class ClassDashboard extends StatefulWidget {
  const ClassDashboard({super.key});

  @override
  State<ClassDashboard> createState() => _InsitituteHomeScreenState();
}

class _InsitituteHomeScreenState extends State<ClassDashboard> {
  List quickMenuTitle = [
    'Create Class',
    'Classes',
    "Add Subjects"
    'Timetable',
    'Add Student',
    'Add Paper',
    'Add Content',
  ];
  List quickMenuImage = [
    'assets/images/teacher1.png',
    'assets/images/teacher2.png',
    'assets/images/teacher3.png',
    'assets/images/teacher4.png',
    'assets/images/teacher5.png',
    'assets/images/teacher6.png',
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

                          ListView.builder(
                           physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: quickMenuImage.length,
                            itemBuilder: (context, index) {
                              print("arslan");
                              return InkWell(
                                onTap: (){
                               index == 5 ? Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => TeacherClasses()),
                               ):null;
/*
                                  _showSimpleDialog(context, _classList["data"][index]["id"].toString(), _classList["data"]);
*/
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Colors.grey.withOpacity(0.3))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(quickMenuImage[index].toString(),scale: 1.3,),
                                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                                            Text(quickMenuTitle[index].toString(),/*_classList["data"][index]["name"].toString()*/style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w600),
                                            ),)
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward,color: Colors.black,)
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