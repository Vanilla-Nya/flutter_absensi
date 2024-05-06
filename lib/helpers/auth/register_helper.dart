import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Place {
  final String id;
  final String name;

  Place({
    required this.id,
    required this.name,
  });

  Place.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String;
}

class Keys {
  final List<String> label;
  Keys({
    required this.label,
  });

  Keys.capitalize(this.label) {
    for (var element in label) {
      const List<String> keyForUpperCase = ["nik", "rt", "rw"];
      if (keyForUpperCase.where((key) => key.contains(element)).isNotEmpty) {
        label[label.indexOf(element)] = element.toUpperCase();
      } else if (element.contains("_")) {
        label[label.indexOf(element)] =
            element.split("_").join(" ").capitalize!;
      } else {
        label[label.indexOf(element)] = element.capitalize!;
      }
    }
  }
}

class VerificationData {
  final String name;
  final bool isValid;
  final int? length;

  VerificationData({
    required this.name,
    required this.isValid,
    this.length,
  });
}

class RegisterHelper extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final RxInt currentStep = 0.obs;
  final formKeyAuthentication = GlobalKey<FormState>().obs;
  final FocusNode focusDateTime = FocusNode();
  final dateTimeController = TextEditingController();
  final formKeyIdentity = GlobalKey<FormState>().obs;
  final formKeyIdentityAddon = GlobalKey<FormState>().obs;
  final RxMap<String, bool> registerVerification = {
    "nik": false,
    "email": false,
    "password": false,
    "nama": false,
    "tempat_lahir": false,
    "tanggal_lahir": false,
    "provinsi": false,
    "kabupaten": false,
    "kecamatan": false,
    "kelurahan": false,
    "rt": false,
    "rw": false,
    "kode_pos": false,
  }.obs;

  final RxMap<String, dynamic> registerData = {
    "nik": "",
    "email": "",
    "password": "",
    "nama": "",
    "tempat_lahir": "",
    "tanggal_lahir": "",
    "provinsi": "",
    "kabupaten": "",
    "kecamatan": "",
    "kelurahan": "",
    "rt": "",
    "rw": "",
    "kode_pos": "",
  }.obs;

  final RxBool passwordHide = true.obs;

  final RxString provincesValue = "0".obs;
  final RxString regenciesValue = "0".obs;
  final RxString districtsValue = "0".obs;
  final RxString villagesValue = "0".obs;

  @override
  void onInit() {
    super.onInit();
    getDataProvinces();
    focusDateTime.addListener(() {
      if (focusDateTime.hasFocus) {
        dateTimePicker(focusDateTime.context, dateTimeController);
      }
    });
  }

  dateTimePicker(context, controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((value) {
      primaryFocus!.unfocus(disposition: UnfocusDisposition.scope);
      return value;
    });
    if (pickedDate != null) {
      String formattedDate = DateFormat.yMMMMd('in-in').format(pickedDate);
      validatorRegister(
        "tanggal_lahir",
        formattedDate,
      );
      registerData["tanggal_lahir"] = formattedDate;
      controller.text = formattedDate;
    }
  }

  void togglePassword() {
    passwordHide.value = !passwordHide.value;
  }

  void handleRegisterTextFormFieldChanged(name, value) {
    registerData[name] = value;
  }

  helperText(int start, int end) {
    final List verification =
        registerVerification.values.toList().getRange(start, end).toList();
    final List<String?> keys = Keys.capitalize(
      registerVerification.keys.toList().getRange(start, end).toList(),
    ).label;
    final List<String> textHelperValue = [];
    for (var i = 0; i < verification.length; i++) {
      if (!verification[i]) {
        textHelperValue.add(keys[i]!);
      }
    }
    String finalTextHelper = "${textHelperValue.join(", ")}"
        " "
        "${textHelperValue.isNotEmpty ? "Belum Sesuai" : "Sudah Lengkap"}";
    return Row(
      children: textHelperValue.isNotEmpty
          ? [
              Text(
                finalTextHelper,
                style: TextStyle(
                  color: textHelperValue.isEmpty ? Colors.green : Colors.red,
                ),
              ),
              const Gap(5.0),
              const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ]
          : [
              Text(
                finalTextHelper,
                style: TextStyle(
                  color: textHelperValue.isEmpty ? Colors.green : Colors.red,
                ),
              ),
              const Gap(5.0),
              const Icon(
                Icons.check,
                color: Colors.green,
              ),
            ],
    );
  }

  validatorRegister(String name, String? value) {
    // Not Done
    if (value!.isNotEmpty) {
      switch (name) {
        case "nik":
          if (value.length < 16) {
            handleVerification(name, false);
            return "NIK Wajib Diisi dan Minimal 16 Digit";
          } else {
            handleVerification(name, true);
          }
          break;
        case "email":
          if (!value.isEmail) {
            handleVerification(name, false);
            return "Email Tidak Sesuai Format";
          } else {
            handleVerification(name, true);
          }
          break;
        case "nama" ||
              "provinsi" ||
              "kabupaten" ||
              "kecamatan" ||
              "kelurahan" ||
              "tanggal_lahir":
          handleVerification(name, true);
          break;
        case "rt" || "rw":
          if (value.length < 2) {
            handleVerification(name, false);
            return "Minimal 2 Digit";
          } else {
            handleVerification(name, true);
          }
          break;
        case "kode_pos":
          if (value.length < 5) {
            handleVerification(name, false);
            return "Minimal 5 Digit";
          } else {
            handleVerification(name, true);
          }
          break;
        case "tempat_lahir":
          if (value.length < 4) {
            handleVerification(name, false);
            return "Tempat Lahir Minimal Terdiri dari 4 Huruf";
          } else {
            handleVerification(name, true);
          }
          break;
        case "password":
          if (value.length < 8) {
            handleVerification(name, false);
            return "Password Wajib Diisi dan Minimal Terdiri dari 8 Digit";
          } else {
            handleVerification(name, true);
          }
          break;
        default:
      }
    }
  }

  signUp() async {
    if (registerVerification.values
        .toList()
        .every((element) => element == true)) {
      final users = db.collection("Users");
      final checkUserNIK =
          users.where("nik", isEqualTo: registerData["nik"]).limit(1).get();
      await checkUserNIK.then((value) async {
        if (value.docs.isNotEmpty) {
          Get.snackbar("Gagal Daftar", "NIK Telah Terpakai");
        } else {
          registerData["token"] = registerData["password"];
          try {
            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: registerData["email"],
              password: registerData["password"],
            )
                .then((value) async {
              final setUsers = users.doc(value.user!.uid).set(registerData);
              await setUsers.then(
                (value) async {
                  return Get.snackbar(
                    "Berhasil Daftar",
                    "Token Sama Dengan Password !",
                    duration: const Duration(seconds: 5),
                  );
                },
              );
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              Get.snackbar("Gagal Daftar !", "Password Terlalu Pendek !");
            } else if (e.code == 'email-already-in-use') {
              Get.snackbar("Gagal Daftar !", "Email Telah Dipakai !");
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      });
    } else {
      final List falseVerification = registerVerification.values.toList();
      final List falseKeys =
          Keys.capitalize(registerVerification.keys.toList()).label;
      final List<String> emptytFields = [];
      for (var i = 0; i < falseVerification.length; i++) {
        if (!falseVerification[i]) {
          emptytFields.add(falseKeys[i]);
        }
      }
      final String finalEmptyFields = emptytFields.join(", ");
      Get.snackbar(
        "Gagal Daftar !",
        "$finalEmptyFields Belum Diisi/ Salah Format !",
        duration: const Duration(seconds: 30),
        isDismissible: true,
      );
    }
  }

  void handleVerification(name, value) {
    registerVerification[name] = value;
    registerVerification.refresh();
  }

  handleNextButton() {
    if (currentStep.value <= 2) {
      currentStep.value++;
    }
  }

  getDataProvinces() async {
    final provincesData = [];
    final provinces = await get(
      Uri.parse(
          "https://miharin.github.io/api-wilayah-indonesia/api/provinces.json"),
    ).then((value) => jsonDecode(value.body));
    for (var province in provinces) {
      provincesData.add(Place.fromJson(province));
    }
    return provincesData;
  }

  getDataRegencies() async {
    final regenciesData = [];
    final regencies = await get(
      Uri.parse(
          "https://miharin.github.io/api-wilayah-indonesia/api/regencies/${regenciesValue.value}.json"),
    ).then((value) => jsonDecode(value.body));
    for (var regency in regencies) {
      regenciesData.add(Place.fromJson(regency));
    }
    return regenciesData;
  }

  getDataDistrict() async {
    final districtsData = [];
    final districts = await get(
      Uri.parse(
          "https://miharin.github.io/api-wilayah-indonesia/api/districts/${districtsValue.value}.json"),
    ).then((value) => jsonDecode(value.body));
    for (var district in districts) {
      districtsData.add(Place.fromJson(district));
    }
    return districtsData;
  }

  getDataVillage() async {
    final villagesData = [];
    final villages = await get(
      Uri.parse(
          "https://miharin.github.io/api-wilayah-indonesia/api/villages/${villagesValue.value}.json"),
    ).then((value) => jsonDecode(value.body));
    for (var village in villages) {
      villagesData.add(Place.fromJson(village));
    }
    return villagesData;
  }
}
