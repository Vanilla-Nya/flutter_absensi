import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({
    super.key,
    required this.title,
    required this.datalabel,
  });

  final List<String> title;
  final List datalabel;

  @override
  Widget build(BuildContext context) {
    List<Widget> listtitle = title
        .map((label) =>
            Text(label == "nik" ? label.toUpperCase() : label.capitalize!))
        .toList();

    return Flexible(
      flex: 1,
      child: DataTable(
        sortColumnIndex: 0,
        sortAscending: true,
        columns: listtitle.map((title) => DataColumn(label: title)).toList(),
        rows: datalabel.map((e) {
          return DataRow(
            cells: List.generate(
              title.length,
              (index) => DataCell(
                Text(e[title[index]]),
              ),
            ).toList(),
          );
        }).toList(),
      ),
    );
  }
}
