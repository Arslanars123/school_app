import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/add_student.dart';
import 'package:school_app/add_subjects.dart';
import 'package:school_app/institute_login_screen.dart';
import 'package:school_app/updatestudent.dart';
import 'package:school_app/upload_notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ClassSubjects extends StatefulWidget {
  var classId;
  ClassSubjects({required this.classId});
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<ClassSubjects> {
  // Example student data, replace it with your actual data

  var apiResponse;
  bool isLoading = false;
  bool hasError = false;

  Future<void> postData() async {
    setState(() {
      isLoading = true;
      apiResponse = '';
      hasError = false;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String schoolId = prefs.getString('schoolId') ?? '';

    // Check internet connection
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      showToast('No internet connection');
      setState(() {
        isLoading = false;
        hasError = true;
      });
      return;
    }

    // API endpoint
    String apiUrl =
        'http://170.249.216.178/~filterba/schooling/public/api/subjects';
print(prefs.getString("schoolId"));
    try {
      // Make POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'schoolId': 1}),
      );
      apiResponse = jsonDecode(response.body);
      print("data here");
      print(apiResponse);
      // Check status code
      if (response.statusCode == 200) {


      } else {
        // Handle other status codes
        showToast('Failed to post data. Status code: ${response.statusCode}');
        setState(() {
          hasError = true;
        });
      }
    } catch (error) {
      // Handle other errors
      showToast('Error: $error');
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<bool> checkInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        return true; // Device is connected to the internet
      } else {
        return false; // Device is not connected to the internet
      }
    } catch (e) {
      return false; // Error occurred while checking connectivity
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
  Future<void> deleteSubjects(String id) async {
    print(id);
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://170.249.216.178/~filterba/schooling/public/api/subjects-delete'),
      );

      request.fields['subjectId'] = id;

      var response = await request.send();
      var responsedata = await response.stream.bytesToString();
      print("arslan");
      /*   print(responsedata);*/
      var decode = jsonDecode(responsedata);
      Navigator.of(context).pop(); // Close the dialog
      print(decode);

      if (decode["status"] == 200 || decode["status"] == 201) {
        Fluttertoast.showToast(
          msg: "Data sent successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        postData();
      } else {
        throw Exception('Failed to Delete');
      }
    } catch (e) {
      print('Error sending data: $e');
      Navigator.of(context).pop(); // Close the dialog
      Fluttertoast.showToast(
        msg: "Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }
  @override
  void initState() {
    print("arslan");
    print(apiResponse);
    postData();

    super.initState();
  }
 /* void _showSimpleDialog(BuildContext context, var id,var apiResponse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Activity'),
          children: [
            InkWell(
              onTap: () {
                *//*      Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeStudentScreen.builder(context, id: id)),
                );*//*
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.3))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "View",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                *//* print(apiResponse);*//*
                var studentData = apiResponse; // Assuming the student data is in the first index
                var studentName = studentData['name'];
                var studentPicture = studentData['picture'];
                var parentId = studentData['parentId'];
                var classId = studentData['classId'];
                print('Student Name: $studentName');
                print('Student Picture: $studentPicture');
                print('Parent ID: $parentId');
                print('Class ID: $classId');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateStudent(
                      studentId: studentData["id"].toString(), // Assuming 'id' is the student ID
                      name: studentName,
                      image: studentPicture, // Convert picture path to File
                      parent: parentId.toString(),
                      className: classId.toString(),
                      email: apiResponse["email"] ?? "",
                    ),
                  ),
                );

              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.3))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                deleteSubjects(apiResponse["id"].toString());
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.3))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delete",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                )),

            // Add more ListTiles for additional options
          ],
        );
      },
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3E4648),

      body:
      SafeArea(
        child: Stack(

          children: [

            Column(
              children: [

                Container(

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/Frame 7394.png"),
                            Container(
                              decoration: BoxDecoration(
                                  color:Colors.white,
                                  shape: BoxShape.circle
                              ),
                              width: MediaQuery.of(context).size.width/9, // Adjust width and height according to your requirement
                              height:    MediaQuery.of(context).size.height/9,
                              child: CachedNetworkImage(
                                imageUrl:" http://170.249.216.178/~filterba/schooling/public/"+schoolImage.toString(),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error_outline,color: Colors.grey.withOpacity(0.3),),
                                fit: BoxFit.cover,
                              ),
                            ),

                          ],
                        )),
                  ),
                ),


                if (isLoading) Expanded(child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                    ),
                    child: Column(

                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_ios,color: Colors.black,),
                                Text(
                                  'Subjects',
                                  style: TextStyle(
                                    fontFamily: 'Barlow', // Font family
                                    fontWeight: FontWeight.w700, // Weight 700 (bold)
                                    fontSize: 22, // Font size 22px
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(child: CircularProgressIndicator()),
                      ],
                    ))),
                if (hasError)
                  Expanded(child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_forward_ios,color: Colors.black,),
                                  Text(
                                    'Subjects',
                                    style: TextStyle(
                                      fontFamily: 'Barlow', // Font family
                                      fontWeight: FontWeight.w700, // Weight 700 (bold)
                                      fontSize: 22, // Font size 22px
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(child:SizedBox(),),
                        ],
                      ))),

                if (hasError)
                  Expanded(child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                    ),
                    child: RefreshIndicator(
                      onRefresh: postData,
                      child: Column(

                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_forward_ios,color: Colors.black,),
                                  Text(
                                    'Subjects',
                                    style: TextStyle(
                                      fontFamily: 'Barlow', // Font family
                                      fontWeight: FontWeight.w700, // Weight 700 (bold)
                                      fontSize: 22, // Font size 22px
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Icon(Icons.error_outline),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Server Error"),
                        ],
                      ),
                    ),)),

                if ( apiResponse.isNotEmpty)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                      ),

                      child: RefreshIndicator(
                        onRefresh: postData,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back_ios,color: Colors.black,),
                                    Text(
                                      'Subjects',
                                      style: TextStyle(
                                        fontFamily: 'Barlow', // Font family
                                        fontWeight: FontWeight.w700, // Weight 700 (bold)
                                        fontSize: 22, // Font size 22px
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 10,right: 10),
                                itemCount: apiResponse["data"].length,
                                itemBuilder: (BuildContext context, int index) {
                                  print("datacheck");
                                  print(apiResponse);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _buildStudentListItem(apiResponse["data"][index],index.toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height/14,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AddSubjects()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCBAC78), // Use the color CBAC78
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set rounded corner radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('Add Subjects',  style: GoogleFonts.barlow(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildStudentListItem(var apiData,var value) {
    return  InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  AddContent(gradeId: widget.classId, subjectId: apiData["id"])),
        );
      },
      child: Container(

        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 0.5,color: Colors.grey.withOpacity(0.3))
        ),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              apiData["name"] ?? "",
              maxLines: 1,
              style: GoogleFonts.barlow(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );

  }
}
class CircleAvatarWithNetworkImage extends StatelessWidget {
  final String imageUrl;
  final ImageProvider placeholder;
  var width;

  CircleAvatarWithNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius:width ?? MediaQuery.of(context).size.width / 13,
      backgroundColor: Colors.transparent, // Set your desired background color
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child; // If image is fully loaded, return the child (network image)
            } else {
              return Image(image: placeholder); // If image is still loading, return the placeholder
            }
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image(image: placeholder); // If error loading image, return the placeholder
          },
        ),
      ),
    );
  }
}