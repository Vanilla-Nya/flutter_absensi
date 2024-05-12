import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/protected/table_user_helper.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_card/custom_card.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
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
            CustomTextFormField(
              label: "Email",
              verification: true,
              onSave: (value) =>
                  tableUserHelper.handleAddNewtableContent("Email", value),
            ),
            CustomTextFormField(
              label: "Password",
              verification: true,
              onSave: (value) =>
                  tableUserHelper.handleAddNewtableContent("Password", value),
            ),
            CustomTextFormField(
              label: "Nama",
              verification: true,
              onSave: (value) =>
                  tableUserHelper.handleAddNewtableContent("Nama", value),
            ),
            CustomTextFormField(
              label: "No.Telp",
              verification: true,
              onSave: (value) =>
                  tableUserHelper.handleAddNewtableContent("No.Telp", value),
            ),
            CustomFilledButton(
              label: "Submit",
              onPressed: () {
                tableUserHelper.handleSubmitAddDataContent();
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
