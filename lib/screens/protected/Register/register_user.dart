import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/protected/table_user_helper.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_card/custom_card.dart';
import 'package:flutter_absensi/widget/custom_choice_chip/custom_choice_chip.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterUser extends StatelessWidget {
  RegisterUser({super.key});

  final tableUserHelper = Get.put(TableUserHelper());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomCardWithHeader(
        header: "Register",
        children: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomTextFormField(
                  label: "Email",
                  verification: true,
                  controller: tableUserHelper.controller[0],
                  keyboardType: TextInputType.emailAddress,
                  onSave: (value) =>
                      tableUserHelper.handleAddNewtableContent("Email", value),
                ),
                CustomTextFormField(
                  label: "Password",
                  verification: true,
                  controller: tableUserHelper.controller[1],
                  onSave: (value) => tableUserHelper.handleAddNewtableContent(
                      "Password", value),
                ),
              ],
            ),
            Row(
              children: [
                CustomTextFormField(
                  label: "Nama",
                  verification: true,
                  controller: tableUserHelper.controller[2],
                  onSave: (value) =>
                      tableUserHelper.handleAddNewtableContent("Nama", value),
                ),
                CustomTextFormField(
                  label: "No.Telp",
                  verification: true,
                  controller: tableUserHelper.controller[3],
                  keyboardType: TextInputType.number,
                  onSave: (value) => tableUserHelper.handleAddNewtableContent(
                      "No.Telp", value),
                ),
              ],
            ),
            const Gap(10.0),
            CustomFilledButton(
              label: "Submit",
              onPressed: () {
                tableUserHelper.handleSubmitAddDataContent();
              },
            ),
          ],
        ),
      ),
    );
  }
}
