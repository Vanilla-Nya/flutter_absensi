import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi/models/user/user_model.dart';
import 'package:flutter_absensi/helpers/global/globals.dart';
import 'package:get/get.dart';

class AuthHelper extends GetxController {
  // Form Key
  final formKeyLogin = GlobalKey<FormState>();

  // Focus Node
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  // AuthData
  final RxMap<String, dynamic> authData = {
    "email": "",
    "password": "",
  }.obs;

  // Obscure Text
  final RxBool obsecureTextPassword = true.obs;

  // Verification
  final RxMap<String, bool> verificationData = {
    "email": false,
    "password": false,
  }.obs;

  // Button Sign In Disabled ?
  final RxBool disabledSignInButton = true.obs;

  // User Is Login ?
  final RxBool userIsLogin = false.obs;

  // listen to Verification Data if All True then Button is Active else Passive
  void handleSignInButton() {
    if (verificationData["email"]! && verificationData["password"]!) {
      disabledSignInButton.value = false;
    } else {
      disabledSignInButton.value = true;
    }
  }

  // Handle Change For TextFormField
  void handleLoginTextFormFieldChanged(name, value) => authData[name] = value;

  // Validator TextFromField In Login Screen
  validatorLogIn(String? name, String? value) {
    // If Value is Not Empty Then Next
    if (value!.isNotEmpty) {
      // Switch Name
      switch (name) {
        // Email
        case "email":
          // If is Email == false then Set Verification to false and
          // Return to Login Screen to Inform Email Is Not Valid
          if (!value.isEmail) {
            handleVerification(name, verificationData[name], false);
            return "Email Tidak Sesuai Format";
          } else {
            // If True then Set Verification to true
            handleVerification(name, verificationData[name], true);
          }
          break;
        // Password
        case "password":
          // If length < 8 then Set Verificaition to false and
          // Return to Login Screen to Inform Password Length Must Be 8 or More
          if (value.length < 8) {
            handleVerification(name, verificationData[name], false);
            return "Password Wajib Diisi dan Minimal Terdiri dari 8 Digit";
          } else {
            // If True then Set Verification to true
            handleVerification(name, verificationData[name], true);
          }
          break;
        default:
      }
    }
  }

  // Handle Verification from validatorLogin
  void handleVerification(name, verification, value) {
    verificationData[name] = value;
    verificationData.refresh();
    handleSignInButton();
  }

  // Handle for Secure Password
  void handleObscureText() {
    obsecureTextPassword.value = !obsecureTextPassword.value;
  }

  // Check User Auth
  Stream<User?> checkAuthState() {
    return FirebaseAuth.instance.authStateChanges();
  }

  // Check User Is Login or Not
  checkIsUserLogin(uid) async {
    // IF UID = null then userIsLogin = false
    if (uid == null) {
      userIsLogin.value = false;
    } else {
      // Change to Get From Cache
      final users = db.collection("Users");
      final query = users.doc(uid).get();

      await query.then((userData) async {
        if (userData.data()!.isNotEmpty) {
          userIsLogin.value = true;
        } else {
          userIsLogin.value = false;
        }
      });
    }
  }

  // Handle Sign In
  void signIn() async {
    // Declare Error Message
    String errorMessage = "";

    // Try Sign In With Email and Password Provided By User
    try {
      await auth
          .signInWithEmailAndPassword(
        email: authData["email"],
        password: authData["password"],
      )
          .then((userCredential) async {
        if (userCredential.user?.uid.runtimeType != null) {
          // Get Data If Success
          final users = db.collection("Users");
          final query = users.doc(userCredential.user?.uid).get();
          await query.then((value) async {
            if (value.data()!.isNotEmpty) {
              final user = UserModel.fromJson(value.data()!);
              // Send to Cache With Name "User"
              cache.write("user", {
                "email": user.email,
                "name": user.name,
                "password": user.password,
                "role": user.role,
                "telpNumber": user.number,
              });
              // Set User Is Login to true
              userIsLogin.value = true;
              // Inform User with Snackbar
              return Get.snackbar(
                "Login Success",
                "Welcome ${user.email.split("@")[0]}",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          });
        }
      });
    } on FirebaseAuthException catch (error) {
      // If Error From Firebase
      if (error.code == "network-request-failed") {
        errorMessage = "Database Timeout";
      } else if (error.code == 'invalid-credential') {
        errorMessage = "Email atau Password Salah";
      }
      // Inform User
      Get.snackbar(
        "Login Gagal !",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      // If Error From System
      debugPrint(error.toString());
    }
  }
}
