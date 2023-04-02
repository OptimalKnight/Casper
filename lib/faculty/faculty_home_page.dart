import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/faculty/faculty_enrollments_page.dart';
import 'package:casper/faculty/faculty_panel_management_page.dart';
import 'package:casper/faculty/faculty_panels_page.dart';
import 'package:casper/student/project_page.dart';
import 'package:flutter/material.dart';

class FacultyHomePage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userRole, projectId;

  const FacultyHomePage({
    Key? key,
    required this.userRole,
    this.projectId = -1,
  }) : super(key: key);

  @override
  State<FacultyHomePage> createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  var options = [
        'My Enrollments',
        'My Panels',
      ],
      selectedOption = 1;

  dynamic displayPage;

  void showProject(projectId) {
    setState(() {
      displayPage = ProjectPage(
        project_id: projectId,
        isFaculty: true,
      );
    });
  }

  void selectOption(option) {
    setState(() {
      selectedOption = option;
      switch (option) {
        case 0:
          displayPage = FacultyEnrollmentsPage(
            role: widget.userRole,
            showProject: showProject,
          );
          break;
        case 1:
          displayPage = FacultyPanelsPage(
            role: widget.userRole,
          );
          break;
        case 2:
          displayPage = FacultyPanelManagementPage(
            userRole: widget.userRole,
          );
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.userRole == 'co') {
      options = [
        'My Enrollments',
        'My Panels',
        'Panel Management',
      ];
    }

    displayPage = FacultyPanelsPage(
      role: widget.userRole,
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;

    return Row(
      children: [
        Container(
          width: 300 * fem,
          color: const Color(0xff545161),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < options.length; i++) ...[
                    CustomisedSidebarButton(
                      text: options[i],
                      isSelected: (selectedOption == (i)),
                      onPressed: () => selectOption(i),
                    )
                  ],
                ],
              ),
            ],
          ),
        ),
        displayPage,
      ],
    );
  }
}
