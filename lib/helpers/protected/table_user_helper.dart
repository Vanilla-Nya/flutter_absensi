import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableUserHelper extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;
  final RxMap<String, dynamic> addNewTableContentData = {
    "Email": "",
    "Password": "",
    "Nama": "",
    "No.Telp": "",
  }.obs;
  final controller = List.generate(5, (index) => TextEditingController());

  handleAddNewtableContent(String name, dynamic value) {
    addNewTableContentData[name] = value;
  }

  handleSubmitAddDataContent() {
    tableContent.add({...addNewTableContentData});
    tableContent.refresh();
    for (var element in controller) {
      element.clear();
    }
  }

  handleNewTableContentOnSubmit() {
    tableContent.add(addNewTableContentData);
    tableContent.refresh();
  }
}
