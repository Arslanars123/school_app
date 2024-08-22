import 'package:flutter/material.dart';
import 'package:school_app/add_class.dart';
import 'package:school_app/add_student.dart';
import 'package:school_app/add_subjects.dart';
import 'package:school_app/class_dashboard.dart';
import 'package:school_app/classes.dart';
import 'package:school_app/insititute_home.dart';
import 'package:school_app/institute_home_screen.dart';
import 'package:school_app/login_student_screen.dart';
import 'package:school_app/mp4_example.dart';
import 'package:school_app/onboarding.dart';
import 'package:school_app/students_list_screen.dart';
import 'package:school_app/subjects_list.dart';
import 'package:school_app/teachers.dart';
import 'package:school_app/upload_notes.dart';

import 'institute_login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: false,
      ),
      home: OnboardingScreensDots(),
    );
  }
}
