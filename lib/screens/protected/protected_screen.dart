import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/auth/auth_helper.dart';
import 'package:flutter_absensi/helpers/global/globals.dart';
import 'package:flutter_absensi/screens/protected/dashboard/dashboard_screen.dart';

import 'package:flutter_absensi/widget/custom_appbar/custom_appbar.dart';
import 'package:get/get.dart';

class ProtectedScreen extends StatelessWidget {
  ProtectedScreen({super.key, required this.child, required this.title});
  final String title;
  final Widget child;

  final MyDrawerController _myDrawer = Get.put(MyDrawerController());
  final AuthHelper _isUserLogin = Get.put(AuthHelper());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppbar(
        title: title,
        leading: IconButton(
          onPressed: _myDrawer.toggleDrawer,
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut().then((value) => print("Logout"));
                cache.write("userIsLogin", false);
                _isUserLogin.userIsLogin.value = false;
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: child,
    );
  }
}
