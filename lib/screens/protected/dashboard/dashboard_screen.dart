import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/helpers/auth/auth_helper.dart';
import 'package:flutter_praktek_dokter/screens/protected/protected_screen.dart';
import 'package:flutter_praktek_dokter/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_praktek_dokter/widget/custom_divider/custom_divider.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final AuthHelper _isUserLogin = Get.put(AuthHelper());
  final MyDrawerController _myDrawer = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _myDrawer.zoomDrawerController,
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      style: DrawerStyle.defaultStyle,
      drawerShadowsBackgroundColor: Colors.grey[300]!,
      slideWidth: MediaQuery.of(context).size.width * 0.3,
      menuScreen: const DrawerMenu(),
      mainScreen: MainScreen(isUserLogin: _isUserLogin),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required AuthHelper isUserLogin,
  }) : _isUserLogin = isUserLogin;

  final AuthHelper _isUserLogin;

  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      title: "Dashboard Screen",
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: CustomFilledButton(
                      label: "Logout",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        _isUserLogin.userIsLogin.value = false;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
              title: const Text("Dashboard"),
              onTap: () {
                print("Dashboard");
              },
            ),
            const CustomDivider(
              space: 15.0,
            ),
            ExpansionTile(
              leading: const Icon(Icons.people_rounded),
              title: const Text('Pasien'),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: [
                ListTile(
                  leading: const Icon(Icons.leaderboard_rounded),
                  title: const Text("Data Pasien"),
                  onTap: () {
                    print("Data Pasien");
                    Get.toNamed("/test");
                  },
                ),
              ],
            )
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
