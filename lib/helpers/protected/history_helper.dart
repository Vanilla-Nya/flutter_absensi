import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/global/globals.dart';
import 'package:flutter_absensi/models/user/user_model.dart';
import 'package:get/get.dart';

class HistoryHelper extends GetxController {
  // Get User Cache Role and Name
  final String cacheRole = cache.read("user")["role"];
  final cacheUsername = cache.read("user")["name"];

  // Data History
  final RxList userDataCheck = [].obs;

  @override
  void onInit() {
    super.onInit();

    // Fetch This While Building Widgets
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() async {
    // Date Now
    final date = DateTime.now();

    // Get Year
    final year = date.year;

    // Get Month
    var month = date.month;

    // First Day
    const day = "01";

    // Get This Month From Day One
    final dateNow = DateTime.parse(
        "$year-${month.toString().length == 1 ? "0$month" : month}-$day");

    // To Last Day of The Month
    final dateThen =
        DateTime.parse("$year-${month++ <= 9 ? "0$month" : month}-$day");

    // Collection
    final timeCollection = db.collection("TimeStamp");

    // Query
    Future<QuerySnapshot<Map<String, dynamic>>> query;

    // If Admin Get ALl Data In Database
    if (cacheRole == "admin") {
      query = timeCollection.where("year", isEqualTo: year.toString()).get();
    }

    // Else Get Data Where Name == Name In Login and this Year
    else {
      query = timeCollection
          .where("name", isEqualTo: cacheUsername)
          .where("year", isEqualTo: year.toString())
          .get();
    }

    // Logic Get Data
    await query.then((timestamps) {
      // Looping Timestamps if cacheRole Admin This Will Loop for a While
      for (var timestamp in timestamps.docs) {
        // Looping Inside Timestamp field Where Main Data History Stored
        for (var timestampData in timestamp["timestamp"]) {
          // Change Type to DateTime from String
          final date = DateTime.parse(timestampData["DateTime"]);
          // If DateNow <= Date < DateThen
          if (date.isAfter(dateNow) && date.isBefore(dateThen)) {
            // Adding In The UserDataCheck With User History Model Configuratuion
            userDataCheck.add(UserHistoryModel.fromJson(
              timestampData,
              timestamp["name"],
            ));
            // Test Data
            print(timestampData);
          }
        }
      }
    });
  }
}
