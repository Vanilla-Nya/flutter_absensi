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

  handleAddNewtableContent(String name, dynamic value) {
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
