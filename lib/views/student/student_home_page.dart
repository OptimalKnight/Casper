import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/views/shared/no_projects_found_page.dart';
import 'package:casper/views/shared/project_page.dart';
import 'package:casper/scaffolds/student_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  var courses = [
    'CP301',
    'CP302',
    'CP303',
  ];

  // ignore: prefer_typing_uninitialized_variables
  var selectedOption, projectPage;
  var uid;

  @override
  void initState() {
    super.initState();
    selectedOption = 1;
    projectPage = NoProjectsFoundPage();
    FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      fetchProject(value.docs[0]['proj_id'][selectedOption - 1]);
    });
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  fetchProject(var projectId) {
    setState(() {
      projectPage = ProjectPage(
        projectId: projectId,
      );
    });
  }

  void selectCourse(selectOption) {
    setState(() {
      selectedOption = selectOption;
    });
    FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      fetchProject(value.docs[0]['proj_id'][selectOption - 1]);
    });
  }

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return StudentScaffold(
      uid: uid,
      studentScaffoldBody: Row(
        children: [
          Container(
            width: 300 * fem,
            color: const Color(0xff545161),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < courses.length; i++) ...[
                      CustomisedSidebarButton(
                        text: courses[i],
                        isSelected: (selectedOption == (i + 1)),
                        onPressed: () => selectCourse(i + 1),
                      )
                    ],
                  ],
                ),
              ],
            ),
          ),
          projectPage,
        ],
      ),
    );
  }
}