import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absensi/helpers/protected/table_place_helper.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_card/custom_card.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:get/get.dart';

class RegisterPlace extends StatelessWidget {
  RegisterPlace({super.key});

  final tablePlaceHelper = Get.put(TablePlaceHelper());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomCardWithHeader(
        header: "Register Place",
        children: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              label: "ID",
              verification: true,
              onSave: (value) =>
                  tablePlaceHelper.handleAddNewtableContent("ID", value),
            ),
            CustomTextFormField(
              label: "LatitudeStart",
              verification: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatter: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                      '^[-+]?((90(\\.0)?)|([1-8]?\\d{0,1}(\\.\\d{0,7})?)|(-90(\\.0)?))'),
                )
              ],
              onSave: (value) => tablePlaceHelper.handleAddNewtableContent(
                  "LatitudeStart", value),
            ),
            CustomTextFormField(
              label: "LatitudeEnd",
              verification: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatter: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                      '^[-+]?((90(\\.0)?)|([1-8]?\\d{0,1}(\\.\\d{0,7})?)|(-90(\\.0)?))'),
                )
              ],
              onSave: (value) => tablePlaceHelper.handleAddNewtableContent(
                  "LatitudeEnd", value),
            ),
            CustomTextFormField(
              label: "LongitudeStart",
              verification: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(
                    '^[-+]?((180(\\.0)?)|([1-8]?\\d{0,2}(\\.\\d{0,7})?)|(-180(\\.0)?))'))
              ],
              onSave: (value) => tablePlaceHelper.handleAddNewtableContent(
                  "LongitudeStart", value),
            ),
            CustomTextFormField(
              label: "LongitudeEnd",
              verification: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatter: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                      '^[-+]?((180(\\.0)?)|([1-8]?\\d{0,2}(\\.\\d{0,7})?)|(-180(\\.0)?))'),
                )
              ],
              onSave: (value) => tablePlaceHelper.handleAddNewtableContent(
                  "LongitudeEnd", value),
            ),
            CustomFilledButton(
              label: "Submit",
              onPressed: () {
                tablePlaceHelper.handleSubmitAddDataContent();
              },
            ),
            CustomFilledButton(
              label: "To User Table",
              onPressed: () {
                Get.toNamed("/test");
              },
            ),
          ],
        ),
      ),
    );
  }
}
