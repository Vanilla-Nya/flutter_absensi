import 'package:get/get.dart';

class SigninSignOutHelper extends GetxController {
  final value = 0.obs;
  final datetimeIN = "".obs;
  final datetimeOut = "".obs;
  final status = "".obs;
  final isCheckIn = false.obs;
  final isCheckOut = false.obs;

  handleChange(selected, index) {
    status.value = index == 1 ? "Ijin" : "Sakit";
    value.value = selected ? index : null;
    print(value.value == 1 ? "Ijin" : "Sakit");
  }

  handleTimechange() {
    isCheckIn.value = !isCheckIn.value;
    datetimeIN.value = DateTime.now().toString();
  }

  handleTimechangeOut() {
    isCheckOut.value = !isCheckOut.value;
    isCheckIn.value = !isCheckIn.value;
    datetimeOut.value = DateTime.now().toString();
  }
}
