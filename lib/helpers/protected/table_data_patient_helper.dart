import 'package:get/get.dart';

class DataPatient {
  final String nama;

  DataPatient({required this.nama});
}

class DataPatientHelper extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;
  final RxMap<String, dynamic> addNewTableContentData = {
    "nama": "",
    "nik": "",
  }.obs;

  handleAddNewTableContent(String name, dynamic value) {
    addNewTableContentData[name] = value;
  }

  handleSubmitAddDataContent() {
    tableContent.add({...addNewTableContentData});
    tableContent.refresh();
  }

  handleNewTableContentOnSubmit() {
    tableContent.add(addNewTableContentData);
    tableContent.refresh();
  }
}
