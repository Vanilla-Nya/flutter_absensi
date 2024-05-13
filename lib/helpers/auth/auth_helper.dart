import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi/models/user/authentication_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthData {
  final String email;
  final String password;

  AuthData({
    required this.email,
    required this.password,
  });
}

class AuthHelper extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final formKeyLogin = GlobalKey<FormState>().obs;
  final formKeyToken = GlobalKey<FormState>().obs;
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();
  final RxMap<String, dynamic> authData = {
    "email": "",
    "password": "",
  }.obs;

  final RxMap<String, bool> obscureText = {
    "password": true,
  }.obs;

  final RxMap<String, bool> verificationData = {
    "email": false,
    "password": false,
  }.obs;

  final RxBool disabledSignInButton = true.obs;
  final RxBool userIsLogin = false.obs;

  void handleSignInButton() {
    if (verificationData["email"]! && verificationData["password"]!) {
      disabledSignInButton.value = false;
    } else {
      disabledSignInButton.value = true;
    }
  }

  void handleLoginTextFormFieldChanged(name, value) => authData[name] = value;

  validatorLogIn(String? name, String? value) {
    if (value!.isNotEmpty) {
      switch (name) {
        case "email":
          if (!value.isEmail) {
            handleVerification(name, verificationData[name], false);
            return "Email Tidak Sesuai Format";
          } else {
            handleVerification(name, verificationData[name], true);
          }
          break;
        case "password":
          if (value.length < 8) {
            handleVerification(name, verificationData[name], false);
            return "Password Wajib Diisi dan Minimal Terdiri dari 8 Digit";
          } else {
            handleVerification(name, verificationData[name], true);
          }
          break;
        default:
      }
    }
  }

  void handleVerification(name, verification, value) {
    verificationData[name] = value;
    verificationData.refresh();
    handleSignInButton();
  }

  void handleObscureText(name) {
    obscureText[name] = !obscureText[name]!;
    obscureText.refresh();
  }

  Stream<User?> checkAuthState() {
    return FirebaseAuth.instance.authStateChanges();
  }

  checkIsUserLogin(uid) async {
    // FirebaseAuth.instance.signOut();
    if (uid == null) {
      userIsLogin.value = false;
    } else {
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

  void signIn() async {
    String errorMessage = "";
    final cacheUser = GetStorage();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: authData["email"],
        password: authData["password"],
      )
          .then((userCredential) async {
        if (userCredential.user?.uid.runtimeType != null) {
          final users = db.collection("Users");
          final query = users.doc(userCredential.user?.uid).get();
          await query.then((value) async {
            if (value.data()!.isNotEmpty) {
              final user = AuthenticationModel.fromJson(value.data()!);
              cacheUser.write("user", {
                "email": user.email,
                "name": user.name,
                "password": user.password,
                "role": user.role,
                "telpNumber": user.telpNumber,
              });
              userIsLogin.value = true;
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
      if (error.code == "user-not-found") {
        errorMessage = "Email Tidak Terdaftar";
      } else if (error.code == 'wrong-password') {
        errorMessage = "Password Salah";
      } else {
        print(error);
        errorMessage = "Email Atau Password Salah";
      }
      Get.snackbar(
        "Login Gagal !",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
