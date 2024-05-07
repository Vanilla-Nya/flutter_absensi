import 'package:get/get.dart';

class SigninSignOutHelper extends GetxController {
  final value = 0.obs;
  handleChange(selected, index) {
    value.value = selected ? index : null;
    print(value.value == 1 ? "Ijin" : "Sakit");
  }
}
