import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/screens/protected/dashboard/dashboard_screen.dart';

import 'package:flutter_praktek_dokter/widget/custom_appbar/custom_appbar.dart';
import 'package:get/get.dart';

class ProtectedScreen extends StatelessWidget {
  ProtectedScreen({super.key, required this.child, required this.title});
  final String title;
  final Widget child;

  final MyDrawerController _myDrawer = Get.put(MyDrawerController());

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
      ),
      body: child,
    );
  }
}
