import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:school_app/utils/paths.dart';
class StudentLoginScreen extends StatefulWidget {
  StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _LoginOneScreenState();
}

class _LoginOneScreenState extends State<StudentLoginScreen> {


  bool loader = false;
  var responsedata;
  Future<void> loginUser(String email, String password, String instituteId) async {
    print(email);
    print(password);
    print(instituteId);
    setState(() {
      loader = true;
    });
    // Check if email is valid using a basic regular expression
    bool isEmailValid = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);

    if (!isEmailValid) {
      Fluttertoast.showToast(
          msg: "Invalid email address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    // Check if any controller is empty
    if (email.isEmpty || password.isEmpty || instituteId.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill in all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loader = false;
      });
      return;
    }

    // Check internet status
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "No internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loader = false;
      });
      return;
    }

    // API endpoint
    var apiUrl = "http://170.249.216.178/~filterba/schooling/public/api/login-student";

    try {
      // Prepare request body
      var requestBody = {
        "email": email,
        "password": password,
        "code": instituteId,
      };
      var body = jsonEncode(requestBody);

      // Make POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {

        responsedata = json.decode(response.body);
        print(responsedata);
        if(responsedata["data"]['id'] != null){
          Fluttertoast.showToast(
              msg: "LogIn Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          print(responsedata);
          /*     Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  HomeTeacherOneScreen.builder(context,id: responsedata["data"]["id"])),
        );*/
        }


      } else {
        print("Failed to login. Status code: ${response.statusCode}");
      }
    } catch (error) {
      // Handle other errors
      print("Error: $error");
    }

    setState(() {
      loader = false;
    });
  }
  bool _isObscure = true;
  hidePassword (){
    _isObscure == false ?  setState(() {
      _isObscure = true;
      print(_isObscure);
    }):setState((){
      _isObscure = false;
    });
  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3E4648),
        resizeToAvoidBottomInset: false,
        body: Column(
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
                    child: Image.asset("assets/images/Frame 7394.png")),
              ),
            ),
            Expanded(
              child: Container(

                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Column(
                  children: [
                    _buildLoginForm(context),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginForm(BuildContext context) {

    return    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/30),
            Text(
              "Sign in as Student",
              style: GoogleFonts.barlow(
                fontSize: 27,
                fontWeight: FontWeight.w700,
                height: 1.2, // line height equivalent
                letterSpacing: -1,

              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30),

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
                  hintText: 'Email',
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
            SizedBox(height: MediaQuery.of(context).size.height/30),
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
            SizedBox(height: MediaQuery.of(context).size.height/30),

            Container(
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
                      controller: instituteController,

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
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30),
            Text(
              "Forgot Password ?",
              style:   GoogleFonts.barlow(

                fontSize: 14, // Font size
                fontWeight: FontWeight.w700,
                color:Color(0xFFCBAC78),
                // Font weight
                height: 1.2, // Line height equivalent
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  loginUser(emailController.text, passwordController.text, instituteController.text);

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
                  'Next',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16.0, // Font size
                  ),
                ),
              ),
            ),
            Center(child:loader == true? CircularProgressIndicator():SizedBox())
          ],
        ),
      ),
    );
  }
}
// ignore_for_file: must_be_immutable



class CustomImageView extends StatelessWidget {
  ///[imagePath] is required parameter for showing image
  String? imagePath;

  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? radius;
  BoxBorder? border;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView({
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment!,
      child: _buildWidget(),
    )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return Container(
            height: height,
            width: width,
            child: SvgPicture.asset(imagePath!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.contain,
                colorFilter:
                ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn)),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
            color: color,
            placeholder: (context, url) => Container(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
            ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
      }
    }
    return SizedBox();
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }
