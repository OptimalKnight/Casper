import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/faculty/faculty_panel_management_page.dart';
import 'package:flutter/material.dart';

class PanelsDataTable extends StatefulWidget {
  final List<Panel> panels;

  const PanelsDataTable({
    super.key,
    required this.panels,
  });

  @override
  State<PanelsDataTable> createState() => _PanelsDataTableState();
}

class _PanelsDataTableState extends State<PanelsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  // TODO: View assigned teams, remove team, add team
  void viewPanel(panel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  CustomisedText(
                    text: 'Panel: ${panel.id}',
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              CustomisedText(
                text: '${panel.evaluators}',
                fontSize: 20,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomisedButton(
                width: 100,
                height: 50,
                text: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.panels.isEmpty) {
      return SizedBox(
        height: 560,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[300],
                size: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomisedText(
                text: 'No panels found',
                color: Colors.grey[300],
                fontSize: 30,
              ),
            ],
          ),
        ),
      );
    }

    final columns = [
      'ID',
      'Number Of Evaluators',
      'Evaluators',
      'View Details',
    ];

    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white)),
      child: DataTable(
        border: TableBorder.all(
          width: 2,
          borderRadius: BorderRadius.circular(2),
          color: const Color.fromARGB(255, 43, 40, 40),
        ),
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(widget.panels),
        headingRowColor: MaterialStateColor.resolveWith(
          (states) {
            return const Color(0xff12141D);
          },
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    var headings = [
      DataColumn(
        label: CustomisedText(
          text: columns[0],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[1],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[2],
        ),
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[3],
        ),
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<Panel> rows) => rows.map(
        (Panel panel) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: panel.id.toString(),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: panel.numberOfEvaluators.toString(),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 400,
                child: CustomisedOverflowText(
                  text: panel.evaluators,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedButton(
                text: const Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                ),
                height: 37,
                width: double.infinity,
                onPressed: () => viewPanel(panel),
                elevation: 0,
              ),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.all(
              const Color.fromARGB(255, 212, 203, 216),
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.panels.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.id.toString(),
          panel2.id.toString(),
        ),
      );
    } else if (columnIndex == 1) {
      widget.panels.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.numberOfEvaluators.toString(),
          panel2.numberOfEvaluators.toString(),
        ),
      );
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
}
