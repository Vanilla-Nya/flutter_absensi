import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/protected/table_place_helper.dart';
import 'package:flutter_absensi/widget/custom_data_table/custom_data_table.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:get/get.dart';

class TablePlace extends StatelessWidget {
  TablePlace({super.key});

  final tablePlaceHelper = Get.put(TablePlaceHelper());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                tablePlaceHelper.tableContent.isEmpty
                    ? const CustomDataTable(
                        title: [
                          "ID",
                          "Latitude Start",
                          "Latitude End",
                          "Longitude Start",
                          "Longitude End",
                        ],
                        datalabel: [
                          {
                            "ID": "",
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
      ],
    );
  }
}
