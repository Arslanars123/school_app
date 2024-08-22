import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'institute_login_screen.dart';
class ClassesListScreen extends StatefulWidget {
  @override
  _ClassesListScreenState createState() => _ClassesListScreenState();
}

class _ClassesListScreenState extends State<ClassesListScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  var _classList;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> deleteCLasses(String id) async {
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
        Uri.parse('http://170.249.216.178/~filterba/schooling/public/api/grades-delete'),
      );

      request.fields['studentId'] = id;

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
      _fetchData();
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
  void _showSimpleDialog(BuildContext context, var id,var apiResponse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Activity'),
          children: [
            InkWell(
              onTap: () {
                /*      Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeStudentScreen.builder(context, id: id)),
                );*/
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
                deleteCLasses(apiResponse["id"].toString());
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
  }
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection.');
      }

      final prefs = await SharedPreferences.getInstance();
      String apiUrl = 'http://170.249.216.178/~filterba/schooling/public/api/grades';

      // Prepare form data
      var formData = {
        "schoolId": prefs.getString("schoolId"),
      };
      var encode = json.encode(formData);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: encode,
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        setState(() {
          _classList = jsonDecode(response.body);
          print(_classList);
          _isLoading = false;
          _hasError = false;
          _errorMessage = '';
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3E4648),

      body: SafeArea(
        child: Column(
          children: [
            Container(

              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              decoration: BoxDecoration(

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
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
             ),
            /*   #171721
*/
             child:    Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("Classes",style: GoogleFonts.barlow(textStyle:TextStyle(fontSize: 22,fontWeight: FontWeight.w700)) ),
                 ),

                 Expanded(
                   child: _isLoading
                       ? Center(child: CircularProgressIndicator())
                       : _hasError
                       ? Center(child: Text('Error: $_errorMessage'))
                       : _classList == null || _classList!.isEmpty
                       ? Center(child: Text('No data available'))
                       : ListView.builder(
                     shrinkWrap: true,
                     itemCount: _classList["data"].length,
                     itemBuilder: (context, index) {
                       print("arslan");
                       return InkWell(
                         onTap: (){
                           _showSimpleDialog(context, _classList["data"][index]["id"].toString(), _classList["data"]);
                         },
                         child: Container(
                           margin: EdgeInsets.only(left: 10,right: 10),
                           width: double.infinity,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(width: 1,color: Colors.grey.withOpacity(0.3))
                           ),
                           child: Padding(
                             padding: const EdgeInsets.all(10),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Row(
                                   children: [
                                     Image.asset("assets/images/seat.png",scale: 1.3,),
                                     SizedBox(width: MediaQuery.of(context).size.width/20,),
                                     Text(_classList["data"][index]["name"].toString(),style: GoogleFonts.lato(
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
                 ),
               ],
             ),
           ),
         )
          ],
        ),
      ),
    );
  }
}
