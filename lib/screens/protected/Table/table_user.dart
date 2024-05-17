import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_absensi/helpers/protected/table_user_helper.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_data_table/custom_data_table.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:get/get.dart';

class TableUser extends StatelessWidget {
  TableUser({super.key});

  final tableUserHelper = Get.put(TableUserHelper());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          children: [
            Obx(
              () => Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    tableUserHelper.tableContent.isEmpty
                        ? const CustomDataTable(
                            title: [
                              "Email",
                              "Password",
                              "Nama",
                              "No.Telp",
                            ],
                            datalabel: [
                              {
                                "Email": "",
                                "Password": "",
                                "Nama": "",
                                "No.Telp": "",
                              }
                            ],
                          )
                        : CustomDataTable(
                            title:
                                tableUserHelper.tableContent[0].keys.toList(),
                            datalabel: tableUserHelper.tableContent,
                            ontap: () => showBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextFormField(
                                          label: ":D",
                                          verification: true,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
