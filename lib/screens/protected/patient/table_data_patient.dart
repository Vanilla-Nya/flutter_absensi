import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/helpers/protected/table_data_patient_helper.dart';
import 'package:flutter_praktek_dokter/widget/custom_data_table/custom_data_table.dart';
import 'package:get/get.dart';
// import 'package:gap/gap.dart';

class TableDataPatient extends StatelessWidget {
  TableDataPatient({super.key});

  final datapatienthelper = Get.put(DataPatientHelper());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () => Get.toNamed('/test1'),
              child: const Text("Submit"),
            ),
          ],
        ),
        Obx(
          () => Card(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                datapatienthelper.tableContent.isEmpty
                    ? const CustomDataTable(
                        title: ['nama', 'nik'],
                        datalabel: [
                          {
                            "nama": "",
                            "nik": "",
                          }
                        ],
                      )
                    : CustomDataTable(
                        title: datapatienthelper.tableContent[0].keys.toList(),
                        datalabel: datapatienthelper.tableContent,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
