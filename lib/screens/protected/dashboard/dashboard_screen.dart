import 'package:flutter/material.dart';
import 'package:flutter_absensi/screens/protected/protected_screen.dart';
import 'package:flutter_absensi/widget/custom_divider/custom_divider.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class DashboardScreen extends GetView<MyDrawerController> {
  const DashboardScreen({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(builder: (_) {
      return ZoomDrawer(
        controller: _.zoomDrawerController,
        borderRadius: 24.0,
        showShadow: true,
        angle: -12.0,
        style: DrawerStyle.defaultStyle,
        drawerShadowsBackgroundColor: Colors.grey[300]!,
        slideWidth: 300,
        menuScreen: const DrawerMenu(),
        mainScreen: child,
      );
    });
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      title: "Dashboard Screen",
      child: child,
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 0.2,
        ),
      ),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.grey[300]!,
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Menu",
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded),
              title: const Text("Absensi"),
              onTap: () {
                Get.toNamed("/");
              },
            ),
            const CustomDivider(
              space: 15.0,
            ),
            ExpansionTile(
              leading: const Icon(Icons.people_alt_rounded),
              title: const Text("User"),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Daftar User"),
                  onTap: () {
                    Get.toNamed("/registered-User");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text("Pendaftaran User"),
                  onTap: () {
                    Get.toNamed("/register-user");
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.location_pin),
              title: const Text('Lokasi'),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: [
                ListTile(
                  leading: const Icon(Icons.location_city_rounded),
                  title: const Text("Lokasi Terdaftar"),
                  onTap: () {
                    Get.toNamed("/registered-location");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.app_registration_rounded),
                  title: const Text("Pendaftaran Tempat"),
                  onTap: () {
                    Get.toNamed("/register-place");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }
}
