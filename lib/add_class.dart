import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'institute_login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class AddClass extends StatefulWidget {
  String? teacherId;

  AddClass({this.teacherId});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkInternetAndFetchData();
  }

  List<Map<String, dynamic>> subjects = [];
  List<dynamic>? dataSubjects;

  Future<void> checkInternetAndFetchData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isLoading = false;
        errorMessage = 'No internet connection';
      });
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final url =
        'http://170.249.216.178/~filterba/schooling/public/api/subjects';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*   try {*/
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'schoolId': "1"}),
    );
    print(response.statusCode);
    print(prefs.getString("schoolId"));
    data = json.decode(response.body);
    print(data.toString() + 'gg');

    if (response.statusCode == 200) {
      for (var dataSubjects in data["data"]) {
        int id = dataSubjects['id'];
        String name = dataSubjects['name'];
        subjects.add({'id': id, 'name': name});
      }
      print(subjects);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage =
            'Failed to load data, status code: ${response.statusCode}';
        isLoading = false;
      });
    }
  }

  TextEditingController subjectController = TextEditingController();
  List<String> suggestions = [
    'Math',
    'Science',
    'History',
    'English'
  ]; // Sample list of suggestions
  bool isLoading = true;
  String? errorMessage;
  var data;
  List<Map<String, dynamic>> filteredSubjects = [];
  List<Map<String, dynamic>> gridList = [];

  @override
  Widget build(BuildContext context) {
    return CustomHeaderWidget(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 5,top: 10,bottom: 0),
                      child: Icon(Icons.arrow_back_ios,color: Colors.black,)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 0),
                      child: Text(
                        'Add Class',
                        style: TextStyle(
                          fontFamily: 'Barlow', // Font family
                          fontWeight: FontWeight.w700, // Weight 700 (bold)
                          fontSize: 22, // Font size 22px
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: controller,
                    style: GoogleFonts.barlow(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color:
                          Color(0xFF8A8A8E), // Set the hint text color to black
                    ), // Change the input text color to black
                    decoration: InputDecoration(
                      hintText: "Class Name",
                      hintStyle: GoogleFonts.barlow(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(
                            0xFF8A8A8E), // Set the hint text color to black
                      ),

                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      border: InputBorder.none, // Remove the underline
                    ),
                    onChanged: (value) {
                      fetchData();
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: subjectController,
                    style: GoogleFonts.barlow(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8A8A8E),
                    ),
                    decoration: InputDecoration(
                      hintText: "subject",
                      hintStyle: GoogleFonts.barlow(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8A8A8E),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      setState(() {
                        print(subjects);

                        filteredSubjects = subjects;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        filteredSubjects = subjects
                            .where((subject) => subject['name']
                                .toLowerCase()
                                .startsWith(value.toLowerCase()))
                            .toList();
                        filteredSubjects.length == 0
                            ? filteredSubjects.add(
                                {'id': 1, 'name': subjectController.text},
                              )
                            : null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        if (isLoading)
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        if (errorMessage != null)
                          Center(
                            child: Text(errorMessage!),
                          ),
                        if (data != null && data.isNotEmpty)
                          ListView.builder(
                            itemCount: filteredSubjects.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(filteredSubjects[index]['name']),
                                onTap: () {
                                  setState(() {
                                    gridList.add(filteredSubjects[index]);
                                    subjectController.text =
                                        filteredSubjects[index]['name'];
                                  });
                                },
                              );
                            },
                          ),
                        if (!isLoading &&
                            errorMessage == null &&
                            (data == null || data.isEmpty))
                          Center(
                            child: Text('No data available'),
                          ),
                      ],
                    ),
                  ),
                ),
                gridList.length != 0
                    ? Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: double.infinity,
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: gridList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            gridList[index]['name'],
                                            maxLines: 1,
                                            style: GoogleFonts.barlow(
                                              color: Color(0xFF3C3C43),
                                              textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () {
                                            setState(() {
                                              gridList.removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                    : SizedBox(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      searchInSubjects(
                        subjects,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Color(0xFFCBAC78),
                      // Background color of the button
                      // Text color
                      minimumSize: Size(double.infinity,
                          50), // Set width to double.infinity and height to 50
                    ),
                    child: Text(
                      'Add Class',
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
        ),
      ),
    );
  }

  List<String> newNames = [];
  List<String> ids = [];

  searchInSubjects(
    List<Map<String, dynamic>> subjects,
  ) {
    ids.clear();
    newNames.clear();
    print("data check karo");
    for (var subject2 in gridList) {
      var name2 = subject2['name'];
      if (subjects.any((subject1) => subject1['name'] == name2)) {
        ids.add(subject2["id"].toString());
      } else {
        newNames.add(subject2["name"]);
      }
    }
    print(newNames);
    if (newNames.length != 0) {
      for (var newSubject in newNames) {
        print("here");
        storeSubjects(newSubject);
      }
    }

    // String not found in the list
  }

  Future<void> storeSubjects(String text) async {
    print("in function");
    final apiUrl =
        'http://170.249.216.178/~filterba/schooling/public/api/subjects-store';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check Internet Connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection.');
      return; // Return without making the request
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({
        'schoolId': "1",
        "name": text,
        "createdBy": "4"
        // Add other subject data here if needed
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print("new upcoming");
      print(decodedResponse);
      if (decodedResponse['status'] == 200) {
        ids.add(decodedResponse["data"]["id"].toString());
        print(ids);
        storeClass();
        Fluttertoast.showToast(
            msg: "Subjects Uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        print('Failed to store subjects. Error: ${decodedResponse['message']}');
      }
    } else {
      print('Failed to store subjects. Status Code: ${response.statusCode}');
      // Handle error as needed
    }
  }

  Future<void> storeClass() async {
    final apiUrl =
        'http://170.249.216.178/~filterba/schooling/public/api/grades-store';

    // Check Internet Connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection.');
      return; // Return without making the request
    }
    var prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'name': controller.text,
          'createdBy': "teacher",
          'schoolId': prefs.getString("schoolId"),
          'teacherId': widget.teacherId ?? "4",
          'subjectsIds': ids,
          'day': "monday",
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      var decode = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(decode);

        Fluttertoast.showToast(
            msg: "Class Uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        print('Failed to store class. Error: ${response.statusCode}');
        // Handle error as needed
      }
    } catch (e) {
      print('Error: $e');
      // Handle error as needed
    }
  }
}

class CustomHeaderWidget extends StatelessWidget {
  final Widget child;

  CustomHeaderWidget({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF3E4648),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/bg.png'),
                ),
              ),
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
                            color: Colors.white, shape: BoxShape.circle),
                        width: MediaQuery.of(context).size.width / 9,
                        // Adjust width and height according to your requirement
                        height: MediaQuery.of(context).size.height / 9,
                        child: CachedNetworkImage(
                          imageUrl:
                              "http://170.249.216.178/~filterba/schooling/public/" +
                                  schoolImage.toString(),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error_outline,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child, // Here is where you'll place your custom widget
          ],
        ),
      ),
    );
  }
}
