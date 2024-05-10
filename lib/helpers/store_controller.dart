import 'package:flutter_absensi/helpers/auth/auth_helper.dart';
import 'package:flutter_absensi/helpers/auth/register_helper.dart';
import 'package:get/get.dart';

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthHelper());
    Get.lazyPut(() => RegisterHelper());
  }
}
