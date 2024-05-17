import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/global/globals.dart';
import 'package:flutter_absensi/models/map/geofencing.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_choice_chip/custom_choice_chip.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SigninSignOutHelper extends GetxController {
  final RxBool isLoading = false.obs;
  final value = 0.obs;
  final datetimeIN = "".obs;
  final datetimeOut = "".obs;
  final status = "".obs;
  final valueAlasan = "".obs;
  final isCheckIn = false.obs;
  final isCheckOut = false.obs;
  final labelCheck = "Check In".obs;
  final RxMap<String, dynamic> currentData = {
    "name": "",
    "timestamp": {
      "latitude": "",
      "longitude": "",
      "status": "",
      "workplaceId": "",
      "DateTime": "",
      "type": "",
    },
  }.obs;

  @override
  void onInit() async {
    super.onInit();
    Geolocator.requestPermission().then((value) {
      if (value == LocationPermission.denied ||
          value == LocationPermission.deniedForever) {
        Get.snackbar("Lokasi Tidak Di Izinkan !", "");
      }
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  handleChange(selected, index) {
    status.value = index == 1 ? "Ijin" : "Sakit";
    if (selected) {
      value.value = index;
    }
    print(value.value == 1 ? "Ijin" : "Sakit");
  }

  handleAlasan(value) {
    valueAlasan.value = value;
  }

  handleAddToDatabase() async {
    final timestamp = db.collection("TimeStamp");
    await timestamp
        .where("name", isEqualTo: currentData["name"])
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        db.collection("TimeStamp").doc().set({
          "name": currentData["name"],
          "timestamp": [
            currentData["timestamp"],
          ]
        }).onError((e, _) => print("Error writing document: $e"));
      } else {
        for (var element in value.docs) {
          db.collection("TimeStamp").doc(element.id).update({
            "timestamp": FieldValue.arrayUnion(
              [currentData["timestamp"]],
            )
          });
        }
      }
    });
  }

  handleTimechange(label, context) async {
    final String currentName = cache.read("user")["name"];
    if (label == "Check In") {
      isCheckIn.value = !isCheckIn.value;
      datetimeIN.value =
          DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString();
      labelCheck.value = "Check Out";
    } else {
      isCheckOut.value = !isCheckOut.value;
      datetimeOut.value =
          DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString();
    }
    final bool isInside =
        await const GeoFencing.square(listSquareGeoFencing: <SquareGeoFencing>[
      SquareGeoFencing(
        id: "Puskesmas Sumber Wringin",
        latitudeStart: -7.9791797,
        latitudeEnd: -7.979752,
        longitudeStart: 113.9933635,
        longitudeEnd: 113.9936065,
      ),
    ]).isInsideSquareGeoFencing();

    Position position = await Geolocator.getCurrentPosition();
    String currentLatitude = position.latitude.toStringAsFixed(7);
    String currentLongitude = position.longitude.toStringAsFixed(7);
    currentData["name"] = currentName;
    currentData["timestamp"]["latitude"] = currentLatitude;
    currentData["timestamp"]["longitude"] = currentLongitude;
    currentData["timestamp"]["DateTime"] =
        label == "Check In" ? datetimeIN.value : datetimeOut.value;
    currentData["timestamp"]["type"] = labelCheck.value;
    if (!isInside) {
      currentData["timestamp"]["status"] = "Outside Workplace";
      currentData["timestamp"]["workplaceId"] = "Unkown";
      currentData["timestamp"]["statusOutside"] = status.value;
      currentData["timestamp"]["alasan"] = valueAlasan.value;
      Get.snackbar("Outside", "");
      return showModalBottomSheet(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height * 0.5,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        context: context,
        builder: (BuildContext context) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomChoiceChip(
                      title: 'Alasan',
                      content: const ["Sakit", "Ijin"],
                      length: 2,
                    ),
                    const Gap(10.0),
                    Obx(() => value.value == 1
                        ? CustomTextFormField(
                            label: "Alasan",
                            verification: true,
                            maxlines: 3,
                            keyboardType: TextInputType.multiline,
                            onSave: (value) => handleAlasan(value),
                          )
                        : const Flexible(child: Text(""))),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.9,
                child: CustomFilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    handleAddToDatabase();
                  },
                  label: "Submit",
                ),
              ),
            ],
          );
        },
      );
    } else {
      currentData["timestamp"]["status"] = "Inside Workplace";
      Map getCurrentWorkplace = await const GeoFencing.square(
          listSquareGeoFencing: <SquareGeoFencing>[
            SquareGeoFencing(
              id: "Puskesmas Sumber Wringin",
              latitudeStart: -7.9791797,
              latitudeEnd: -7.979752,
              longitudeStart: 113.9933635,
              longitudeEnd: 113.9936065,
            ),
          ]).listGeoFencing();
      currentData["timestamp"]["workplaceId"] =
          getCurrentWorkplace["workplaceId"];
      handleAddToDatabase();
      print(position);
      Get.snackbar("Inside", "");
    }
  }
}
