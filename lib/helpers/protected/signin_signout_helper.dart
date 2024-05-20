import 'package:cloud_firestore/cloud_firestore.dart';
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
  final geoFencingList = [].obs;
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Geolocator.requestPermission().then((value) {
        if (value == LocationPermission.denied ||
            value == LocationPermission.deniedForever) {
          Get.snackbar("Lokasi Tidak Di Izinkan !", "");
        }
      });
      _getData();
    });
  }

  void _getData() async {
    final collection = db.collection("TimeStamp");
    final query = collection
        .where("name", isEqualTo: cache.read("user")["name"])
        .limit(1)
        .get();
    if (!isCheckIn.value ||
        !isCheckOut.value ||
        !isCheckIn.value && !isCheckOut.value) {
      await query.then((datas) {
        for (var data in datas.docs) {
          for (var timestamp in data["timestamp"]) {
            final date = DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(timestamp["DateTime"]));
            final dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
            if (date == dateNow && timestamp["type"] == "Check In") {
              isCheckIn.value = true;
            } else if (date == dateNow && timestamp["type"] == "Check Out") {
              isCheckOut.value = true;
            }
          }
        }
      });
    }

    final collectionGeo = db.collection("Place");
    final queryGeo = collectionGeo
        .where("workplace", isEqualTo: "Sumber Wringin")
        .limit(1)
        .get();
    await queryGeo.then((places) {
      for (var place in places.docs) {
        for (var geoFence in place["place"]) {
          final geoFencing = SquareGeoFencing.fromJson(geoFence);
          geoFencingList.add(geoFencing);
        }
      }
    });
    GeoFencing.square(
            listSquareGeoFencing: <SquareGeoFencing>[...geoFencingList])
        .listGeoFencing()
        .then((value) => print(value));
  }

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
          "lastEdit": Timestamp.now(),
          "timestamp": [
            currentData["timestamp"],
          ]
        }).onError((e, _) => print("Error writing document: $e"));
      } else {
        for (var element in value.docs) {
          db.collection("TimeStamp").doc(element.id).update({
            "lastEdit": Timestamp.now(),
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
      datetimeIN.value =
          DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()).toString();
    } else {
      datetimeOut.value =
          DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()).toString();
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
      currentData["timestamp"]["workplaceId"] = "Unknown";
      currentData["timestamp"]["statusOutside"] = status.value;
      currentData["timestamp"]["alasan"] = valueAlasan.value;
      Get.snackbar("Outside", "");
      return widgetOutsideWorkplace(context);
    } else {
      currentData["timestamp"]["status"] = "Inside Workplace";
      // List getCurrentWorkplace = await const GeoFencing.square(
      //     listSquareGeoFencing: <SquareGeoFencing>[
      //       SquareGeoFencing(
      //         id: "Puskesmas Sumber Wringin",
      //         latitudeStart: -7.9791797,
      //         latitudeEnd: -7.979752,
      //         longitudeStart: 113.9933635,
      //         longitudeEnd: 113.9936065,
      //       ),
      //     ]).listGeoFencing();
      // currentData["timestamp"]["workplaceId"] =
      //     getCurrentWorkplace["workplaceId"];
      // handleAddToDatabase();
      Get.snackbar("Inside", "");
    }
  }

  Future<dynamic> widgetOutsideWorkplace(context) {
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
  }
}
