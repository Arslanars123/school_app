import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/utils/paths.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'institute_login_screen.dart';
class UpdateStudent extends StatefulWidget {
  final String studentId;
  final String name;
  final String image;
  final String parent;
  final String className;
  final String email;

  UpdateStudent({
    required this.studentId,
    required this.name,
    required this.image,
    required this.parent,
    required this.className,
    required this.email,
  });

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController instituteIdController = TextEditingController();
  TextEditingController parentController = TextEditingController();
  TextEditingController classController = TextEditingController();
  File? selectedImage;
  bool loading = false;
  bool _isObscure = true;
  hidePassword (){
    _isObscure == false ?  setState(() {
      _isObscure = true;
      print(_isObscure);
    }):setState((){
      _isObscure = false;
    });
  }
  @override
  void initState() {
    parentController.text = widget.parent ?? "";
    classController.text = widget.className ?? "";

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF3E4648),
      body: SafeArea(
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


                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),


                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Edit Student',
                                style: TextStyle(
                                  fontFamily: 'Barlow', // Font family
                                  fontWeight: FontWeight.w700, // Weight 700 (bold)
                                  fontSize: 22, // Font size 22px
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller:nameController,
                                    style: GoogleFonts.barlow(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8A8A8E), // Set the hint text color to black
                                    ), // Change the input text color to black
                                    decoration: InputDecoration(
                                      hintText: widget.name ??"name",
                                      hintStyle: GoogleFonts.barlow(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8E), // Set the hint text color to black
                                      ),
                                      prefixIcon: Icon(Icons.person),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                      border: InputBorder.none, // Remove the underline
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/50),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller:emailController,
                                    style: GoogleFonts.barlow(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8A8A8E), // Set the hint text color to black
                                    ), // Change the input text color to black
                                    decoration: InputDecoration(
                                      hintText: widget.email ??'Email',
                                      hintStyle: GoogleFonts.barlow(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8E), // Set the hint text color to black
                                      ),
                                      prefixIcon: Icon(Icons.email_outlined),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                      border: InputBorder.none, // Remove the underline
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/50),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller:passwordController,
                                    obscureText: _isObscure,
                                    style: GoogleFonts.barlow(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8A8A8E), // Set the hint text color to black
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: GoogleFonts.barlow(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8E),
                                      ),
                                      prefixIcon: Icon(Icons.lock_outline_rounded),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          hidePassword();
                                        },
                                        child: Icon(
                                          _isObscure ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                      border: InputBorder.none, // Remove the underline
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/50),
                            /*    Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                        child: Container(

                                          child: CustomImageView(
                                            imagePath: ImageConstant.imgTelevision,
                                            height: 18,
                                            width: 18,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: TextField(
                                          controller: instituteIdController,

                                          style: GoogleFonts.barlow(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF8A8A8E), // Set the hint text color to black
                                          ),
                                          decoration: InputDecoration(

                                            hintText: 'Institute Code',
                                            hintStyle: GoogleFonts.barlow(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF8A8A8E),
                                            ),


                                            contentPadding:
                                            EdgeInsets.symmetric(vertical: 12.0,horizontal: MediaQuery.of(context).size.width/25),
                                            border: InputBorder.none, // Remove the underline
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
/*
                                SizedBox(height: MediaQuery.of(context).size.height/50),
*/

                                InkWell(
                                  onTap: () {
                                    _showParentNameBottomSheet(context);
                                  },
                                  child:
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      enabled: false,


                                      style: GoogleFonts.barlow(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8E), // Set the hint text color to black
                                      ),
                                      decoration: InputDecoration(
                                        hintText: parentController.text == "" ? "Parents" : parentController.text,
                                        hintStyle: GoogleFonts.barlow(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8A8A8E),
                                        ),
                                        prefixIcon: Icon(Icons.person),
                                        /*suffixIcon: InkWell(
                                onTap: () {
                               *//*   hidePassword();*//*
                                },
                                child: Icon(
                                  _isObscure ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),*/
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                        border: InputBorder.none, // Remove the underline
                                      ),
                                    ),
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/50),

                                InkWell(
                                  onTap: () {
                                    _showClassNameBottomSheet(context);
                                  },
                                  child:
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      enabled: false,


                                      style: GoogleFonts.barlow(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8E), // Set the hint text color to black
                                      ),
                                      decoration: InputDecoration(
                                        hintText: classController.text == "" ? "Class" : classController.text,
                                        hintStyle: GoogleFonts.barlow(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8A8A8E),
                                        ),
                                        prefixIcon: Icon(Icons.person),
                                        /*suffixIcon: InkWell(
                                onTap: () {
                               *//*   hidePassword();*//*
                                },
                                child: Icon(
                                  _isObscure ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),*/
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                        border: InputBorder.none, // Remove the underline
                                      ),
                                    ),
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/50),
                                InkWell(
                                  onTap: () {
                                    _showFilePickerBottomSheet();
                                  },
                                  child:
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      enabled: false,


                                      style: GoogleFonts.barlow(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8E), // Set the hint text color to black
                                      ),
                                      decoration: InputDecoration(
                                        hintText: selectedImage  == null ? "Upload Picture" : selectedImage.toString(),
                                        hintStyle: GoogleFonts.barlow(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8A8A8E),
                                        ),
                                        prefixIcon: Icon(Icons.camera_alt_outlined),
                                        /*suffixIcon: InkWell(
                                onTap: () {
                               *//*   hidePassword();*//*
                                },
                                child: Icon(
                                  _isObscure ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),*/
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                        border: InputBorder.none, // Remove the underline
                                      ),
                                    ),
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/50),
                                loading == true
                                    ? Center(child: CircularProgressIndicator())
                                    : Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _updateStudent();

                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      backgroundColor: Color(0xFFCBAC78), // Background color of the button
                                      // Text color
                                      minimumSize: Size(double.infinity, 50), // Set width to double.infinity and height to 50
                                    ),
                                    child: Text(
                                      'Update Student',
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 16.0, // Font size
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/50),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),


                /*  loading == true
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      _updateStudent();

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Color(0xFFCBAC78), // Background color of the button
                      // Text color
                      minimumSize: Size(double.infinity, 50), // Set width to double.infinity and height to 50
                    ),
                    child: Text(
                      'Add Student',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16.0, // Font size
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilePickerBottomSheet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _updateStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      loading = true;
    });

    try {
      // Check for internet connection
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        // Handle no internet connection
        setState(() {
          loading = false;
        });
        print('No internet connection');
        return;
      }

      print('Name: ${nameController.text}');
      print('Email: ${emailController.text}');
      print('Password: ${passwordController.text}');
      print('Parents: ${parentController.text}');
      print('Name: ${classController.text}');
      print('Name: ${selectedImage}');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://170.249.216.178/~filterba/schooling/public/api/students-update'),
      );
      request.fields.addAll({
        'name': nameController.text,
        'email': emailController.text,
        if (passwordController.text.isNotEmpty)
          'password': passwordController.text,
        'schoolId': prefs.getString("schoolId").toString(),
        'parent': parentController.text,
        'class': classController.text,
        "studentId": widget.studentId,
        'role': "student",
      });


      if (selectedImage != null) {
       /* print("here selected");*/

        request.files.add(
          await http.MultipartFile.fromPath(
            'picture',
            selectedImage!.path,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        // Handle success
      } else {
        print('Error Status Code: ${response.statusCode}');
        print('Error Reason: ${response.reasonPhrase}');
        print('Error Response Body: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Exception: $e');
      // Handle exceptions here
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _showParentNameBottomSheet(BuildContext context) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('http://170.249.216.178/~filterba/schooling/public/api/parents'),
    );
    request.body = json.encode({"schoolId": 1});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      if (jsonResponse.containsKey("data")) {
        var parentList = jsonResponse["data"];

        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Choose Parents",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  // Display parent names from API response
                  for (var parent in parentList)
                    InkWell(
                      onTap: () {
                        setState(() {
                          parentController.text = parent['name'];
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black.withOpacity(0.5), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 5),
                                Text(parent['name']),
                              ],
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      } else {
        print("Invalid API response structure");
        // Handle error
      }
    } else {
      print(response.reasonPhrase);
      // Handle error
    }
  }

  Future<void> _showClassNameBottomSheet(BuildContext context) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('http://170.249.216.178/~filterba/schooling/public/api/grades'),
    );
    request.body = json.encode({"schoolId": 1});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      if (jsonResponse.containsKey("data")) {
        var classList = jsonResponse["data"];
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Choose Class",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  // Display class names from API response
                  for (var className in classList)
                    InkWell(
                      onTap: () {
                        setState(() {
                          classController.text = className['name'];
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black.withOpacity(0.5), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.school),
                                SizedBox(width: 5),
                                Text(className['name']),
                              ],
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      } else {
        print("Invalid API response structure");
        // Handle error
      }
    } else {
      print(response.reasonPhrase);
      // Handle error
    }
  }
}
