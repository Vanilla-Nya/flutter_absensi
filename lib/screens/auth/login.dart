import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/auth/auth_helper.dart';
import 'package:flutter_absensi/widget/custom_card/custom_card.dart';
import 'package:flutter_absensi/widget/custom_form/custom_form.dart';
import 'package:flutter_absensi/widget/custom_text/custom_text.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';

class LoginScreen extends GetView<AuthHelper> {
  const LoginScreen({super.key});

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
                      formKey: controller.formKeyLogin,
                      onChanged: () {
                        controller.handleSignInButton();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextFormField(
                            focusNode: controller.focusEmail,
                            label: "Email",
                            verification: controller.verificationData["email"]!,
                            onSave: (value) =>
                                controller.handleLoginTextFormFieldChanged(
                              "email",
                              value,
                            ),
                            validator: (value) => controller.validatorLogIn(
                              "email",
                              value,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Obx(
                            () => CustomTextFormField(
                              focusNode: controller.focusPassword,
                              label: "Password",
                              obscureText:
                                  controller.obsecureTextPassword.value,
                              verification:
                                  controller.verificationData["password"]!,
                              onSave: (value) =>
                                  controller.handleLoginTextFormFieldChanged(
                                "password",
                                value,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.handleObscureText();
                                },
                                icon: controller.obsecureTextPassword.value
                                    ? const Icon(
                                        Icons.visibility,
                                      )
                                    : const Icon(
                                        Icons.visibility_off,
                                      ),
                              ),
                              validator: (value) {
                                return controller.validatorLogIn(
                                  "password",
                                  value,
                                );
                              },
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),

                          const Gap(10.0),
                          // Button to Input Token

                          Obx(() {
                            if (controller.isLoading.value) {
                              return const CircularProgressIndicator();
                            } else {
                              return CustomFilledButton(
                                label: "Login",
                                onPressed: controller.disabledSignInButton.value
                                    ? null
                                    : () {
                                        controller.signIn();
                                      },
                              );
                            }
                          }),
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
