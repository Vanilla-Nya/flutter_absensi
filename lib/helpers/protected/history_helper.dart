import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/global/globals.dart';
import 'package:flutter_absensi/models/user/user_model.dart';
import 'package:get/get.dart';

class HistoryHelper extends GetxController {
  final String cacheRole = cache.read("user")["role"];
  final RxList userDataCheck = [].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() async {
    final timeCollection = db.collection("TimeStamp");
    final date = DateTime.now();
    final year = date.year;
    var month = date.month;
    const day = "01";
    final dateNow = DateTime.parse(
        "$year-${month.toString().length == 1 ? "0$month" : month}-$day");
    final dateThen =
        DateTime.parse("$year-${month++ <= 9 ? "0$month" : month}-$day");

    switch (cacheRole) {
      case "admin":
        final queryForAdmin = timeCollection.get();
        await queryForAdmin.then((timestamps) {
          for (var timestamp in timestamps.docs) {
            for (var timestampData in timestamp["timestamp"]) {
              final date = DateTime.parse(timestampData["DateTime"]);
              if (date.isAfter(dateNow) && date.isBefore(dateThen)) {
                userDataCheck.add(UserHistoryModel.fromJson(
                  timestampData,
                  timestamp["name"],
                ));
                print(timestampData);
              }
            }
          }
        });
        break;
      case "user":
        final cacheUsername = cache.read("user")["name"];
        final queryForUser =
            timeCollection.where("name", isEqualTo: cacheUsername).get();
        break;
      default:
    }
  }
}
