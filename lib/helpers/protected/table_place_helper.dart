import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TablePlaceHelper extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;
  final RxMap<String, dynamic> addNewTableContentData = {
    "ID": "",
    "LatitudeStart": "",
    "LatitudeEnd": "",
    "LongitudeStart": "",
    "LongitudeEnd": "",
  }.obs;

  handleAddNewtableContent(String name, dynamic value) {
    addNewTableContentData[name] = value;
  }

  handleSubmitAddDataContent() {
    tableContent.add({...addNewTableContentData});
    tableContent.refresh();
    handleAddToDatabase();
  }

  handleNewTableContentOnSubmit() {
    tableContent.add(addNewTableContentData);
    tableContent.refresh();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  handleAddToDatabase() async {
    final place = db.collection("Place");

    await place
        .where("workplace", isEqualTo: "Sumber Wringin")
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        db.collection("Place").doc().set({
          "place": [addNewTableContentData]
        });
      } else {
        for (var element in value.docs) {
          for (var place in element.data()["place"]) {
            if (place["ID"] == addNewTableContentData["ID"]) {
              Get.snackbar("Gagal Menyimpan", "Tempat Sudah Ada!");
            } else {
              db.collection("Place").doc(element.id).update({
                "place": FieldValue.arrayUnion([addNewTableContentData])
              });
            }
          }
        }
      }
    });
  }
}
