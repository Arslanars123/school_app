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
class AddSubjects extends StatefulWidget {


  @override
  State<AddSubjects> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<AddSubjects> {
  TextEditingController nameController = TextEditingController();
  bool loading = false;
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
                                'Add Subject',
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
                                      hintText: 'Subject Name',
                                      hintStyle: GoogleFonts.barlow(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8E), // Set the hint text color to black
                                      ),
                                      prefixIcon: Icon(Icons.book_outlined),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                      border: InputBorder.none, // Remove the underline
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
                                      'Add Subject',
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 16.0, // Font size
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }





  Future<void> _updateStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("schoolId"));

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

      // Encode the data into JSON format
      var requestData = {
        "name": nameController.text,
        'schoolId': prefs.getString("schoolId"),
        "createdBy": "data",
      };
      var encodedData = jsonEncode(requestData);

      final response = await http.post(
        Uri.parse('http://170.249.216.178/~filterba/schooling/public/api/subjects-store'),
        headers: {"Content-Type": "application/json"}, // Specify content type as JSON
        body: encodedData, // Send the encoded JSON data
      );
var decode = jsonDecode(response.body);
print(decode);
      if (response.statusCode == 200) {
        print(response.body);
        // Handle success
      } else {
        print('Error Status Code: ${response.statusCode}');
        print('Error Response Body: ${response.body}');
        // Handle error
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




}
