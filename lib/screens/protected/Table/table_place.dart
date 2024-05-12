import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_absensi/helpers/protected/table_place_helper.dart';
import 'package:flutter_absensi/helpers/protected/table_user_helper.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_data_table/custom_data_table.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:get/get.dart';

class TablePlace extends StatelessWidget {
  TablePlace({super.key});

  final tablePlaceHelper = Get.put(TablePlaceHelper());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Obx(
            () => Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tablePlaceHelper.tableContent.isEmpty
                      ? const CustomDataTable(
                          title: [
                            "LatitudeStart",
                            "LatitudeEnd",
                            "LongitudeStart",
                            "LongitudeEnd",
                          ],
                          datalabel: [
                            {
                              "LatitudeStart": "",
                              "LatitudeEnd": "",
                              "LongitudeStart": "",
                              "LongitudeEnd": "",
                            }
                          ],
                        )
                      : CustomDataTable(
                          title: tablePlaceHelper.tableContent[0].keys.toList(),
                          datalabel: tablePlaceHelper.tableContent,
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
          CustomFilledButton(
            label: "Back",
            onPressed: () {
              Get.toNamed("/test1");
            },
          ),
        ],
      ),
    );
  }
}
