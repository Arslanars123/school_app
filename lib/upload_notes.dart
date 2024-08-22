import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:school_app/subjects_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
class AddContent extends StatefulWidget {
  final gradeId;
  final subjectId;

   AddContent({super.key,required this.gradeId,required this.subjectId});


  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  var images = ["assets/images/word.png",
  "assets/images/pdf.png",
    "assets/images/youtube.png",
    "assets/images/test.png"
  ];
  var title = [
    "Word File",
    "Pdf file",
    "Youtube Video Link",
    "Test",
  ];

  String? wordFilePath;
  String? pdfFilePath;
  String? fileName;
  TextEditingController youtubeLinkController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
bool loading = false;
  void _openFilePicker(String fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [fileType],
    );

    if (result != null) {
      setState(() {
        if (fileType == 'docx') {
          wordFilePath = result.files.single.path;
        } else if (fileType == 'pdf') {
          pdfFilePath = result.files.single.path;
        }
      });
    }
  }


  Future<void> _postContent() async {
    setState(() {
      loading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('http://170.249.216.178/~filterba/schooling/public/api/notes-store');

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'gradeId': widget.gradeId.toString(),
      'subjectId': widget.subjectId.toString(),
      'schoolId': prefs.getString("schoolId").toString(),
      'createdBy': '',
      /*'name': fileNameController.text,*/
      "link":  "test"
    });

    if (youtubeLinkController.text.isNotEmpty && (wordFilePath == null && pdfFilePath == null)) {
      // Send link only
      /*request.fields['link'] = youtubeLinkController.text ;*/
    } else if ((wordFilePath != null || pdfFilePath != null) && youtubeLinkController.text.isEmpty) {
      // Send file only
      if (wordFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath('file', wordFilePath!));
      } else if (pdfFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath('file', pdfFilePath!));
      }
    } else {
      // You need to decide the appropriate behavior when both link and file are provided
      print("Error: Provide either a link or a file, not both.");
      return;
    }

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();

    // Decode the JSON data
    dynamic decodedData = jsonDecode(responseBody);
    print(decodedData);

    // Now you can work with the decoded data
    print(decodedData);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    setState(() {
      loading = false;
    });
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
                          child: Image.asset("assets")
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
                      padding:  EdgeInsets.all(10),
                      child: Row(
                        children: [
                          InkWell(
                              child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                          onTap: (){
                                Navigator.pop(context);
                          },
                          ),
                          Text("Upload Notes",style: GoogleFonts.barlow(textStyle:TextStyle(fontSize: 22,fontWeight: FontWeight.w700)) ),
                        ],
                      ),
                    ),

                    Expanded(
                      child:  ListView.builder(
                        shrinkWrap: true,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          print("arslan");
                          return InkWell(
                            onTap: (){
                              index == 0 ?  _openFilePicker('docx'): index ==1 ?  _openFilePicker('pdf'):index == 2 ? _showBottomSheet(context):null;
                             /* Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  ClassSubjects(classId: _classList["data"][index]["id"].toString())),
                              );*/
                              /*         _showSimpleDialog(context, _classList["data"][index]["id"].toString(), );*/
                            },
                            child: Column(
                              children: [
                                Container(
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
                                            Image.asset(images[index],scale: 1.3,),
                                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                                            Text(title[index].toString(),style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w600),
                                            ),)
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward,color: Colors.black,)
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    loading == true
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          _postContent();

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
                          'Add Content',
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
            )
          ],
        ),
      ),
    );
      /*Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/top_br.png",
              height: 100,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 16),
            // customWidget(text: "Select File", image: "assets/images/word.png",onTap: _showFilePickerBottomSheet),

            customWidget(
              text: "Select File",
              image: "assets/images/word.png",
              onTap: () => _showFilePickerBottomSheet(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextFormField(
                controller: fileNameController,
                decoration: InputDecoration(
                  //labelText: 'EnterFile Name',
                  hintText: 'Enter file name ',
                ),
              ),
            ),
            SizedBox(height: 16),


            SizedBox(height: 16),


            youtubeWidget(image: "assets/images/youtube.png"),
            SizedBox(height: 16),
            customWidget(text: "Test", image: "assets/images/test.png"),
            SizedBox(height: 16),

            InkWell(
              onTap: _postContent,
              child:
              Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Create Content", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400,)),
              ),
            ),

            SizedBox(height: 16),
            if (wordFilePath != null) Center(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text('Word File Path: $wordFilePath'),
            )),
            if (pdfFilePath != null) Center(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text('PDF File Path: $pdfFilePath'),
            )),

          ],
        ),
      ),
    );*/
  }

  customWidget({required final image, required final text, final onTap}) {
    return
      InkWell(
        onTap: onTap,
        child:
        Container(
          height: 88,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(
                image,
                height: 30,
                width: 30,
              ),
              SizedBox(width: 20,),
              Text(text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400,)),
            ],
          ),
        ),
      );
  }

  youtubeWidget({required final image,}) {
    return Container(
      height: 88,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 30,
            width: 30,
          ),
          SizedBox(width: 20,),
          Expanded(
            child: TextFormField(
              controller: youtubeLinkController,
              decoration: InputDecoration(
                hintText: "Youtube Video Link",
                hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add Youtube Link',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Color(0xFF8A8A8E)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller:youtubeLinkController,
                    style: GoogleFonts.barlow(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8A8A8E), // Set the hint text color to black
                    ), // Change the input text color to black
                    decoration: InputDecoration(
                      hintText: "Youtube Video Link",
                      hintStyle: GoogleFonts.barlow(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8A8A8E), // Set the hint text color to black
                      ),
                      prefixIcon: Icon(Icons.circle),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      border: InputBorder.none, // Remove the underline
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _showFilePickerBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text("Select Your File",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,),),
              SizedBox(height: 16),
              customWidget(text: "Word File", image: "assets/images/word.png", onTap: (){
                _openFilePicker('docx');
                Navigator.pop(context);
              }),
              SizedBox(height: 16),
              customWidget(text: "Pdf File", image: "assets/images/pdf.png", onTap: (){
                _openFilePicker('pdf');
                Navigator.pop(context);
              }),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

}






