import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/auth/auth_helper.dart';
import 'package:flutter_absensi/widget/custom_card/custom_card.dart';
import 'package:flutter_absensi/widget/custom_form/custom_form.dart';
import 'package:flutter_absensi/widget/custom_text/custom_text.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _authController = Get.put(AuthHelper());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      // Constrained For Text Field
      var constrained = BoxConstraints(
        maxWidth: constraint.maxWidth > 500 ? 500 : constraint.maxWidth * 0.8,
        minWidth: constraint.maxWidth > 500 ? 500 : constraint.maxWidth * 0.8,
      );

      // Return
      return Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constrained,
            child: FlatCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header
                    const Header(child: "Login"),
                    const Gap(10.0),

                    // Email and Password Text Field with Map
                    // textFields,
                    CustomForm(
                      formKey: _authController.formKeyLogin.value,
                      onChanged: () {
                        _authController.handleSignInButton();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
// on Save and validator simplified with make function and passing the value
                          CustomTextFormField(
                            focusNode: _authController.focusEmail,
                            label: "Email",
                            verification:
                                _authController.verificationData["email"]!,
                            onSave: (value) =>
                                _authController.handleLoginTextFormFieldChanged(
                              "email",
                              value,
                            ),
                            validator: (value) =>
                                _authController.validatorLogIn(
                              "email",
                              value,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Obx(
                            () => CustomTextFormField(
                              focusNode: _authController.focusPassword,
                              label: "Password",
                              obscureText:
                                  _authController.obscureText["password"],
                              verification:
                                  _authController.verificationData["password"]!,
                              onSave: (value) => _authController
                                  .handleLoginTextFormFieldChanged(
                                "password",
                                value,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _authController.handleObscureText("password");
                                },
                                icon: _authController.obscureText["password"]!
                                    ? const Icon(
                                        Icons.visibility,
                                      )
                                    : const Icon(
                                        Icons.visibility_off,
                                      ),
                              ),
                              validator: (value) {
                                return _authController.validatorLogIn(
                                  "password",
                                  value,
                                );
                              },
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),

                          const Gap(10.0),
                          // Button to Input Token
                          CustomFilledButton(
                            label: "Login",
                            onPressed: () {
                              Get.toNamed("/Test1");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
