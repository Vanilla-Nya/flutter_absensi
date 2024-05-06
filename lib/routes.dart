import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/helpers/auth/auth_helper.dart';
import 'package:flutter_praktek_dokter/screens/auth/auth_screen.dart';
import 'package:flutter_praktek_dokter/screens/auth/login.dart';
import 'package:flutter_praktek_dokter/screens/auth/register.dart';
import 'package:flutter_praktek_dokter/screens/protected/patient/register_patient.dart';
import 'package:flutter_praktek_dokter/screens/protected/patient/table_data_patient.dart';
import 'package:flutter_praktek_dokter/screens/protected/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';

final AuthHelper _isUserLogin = Get.put(AuthHelper());

class Routes {
  List<GetPage<dynamic>> routes = [
    GetPage(
        name: '/',
        page: () {
          return CustomRoutes(
            widget: DashboardScreen(),
            secondWidget: AuthScreen(
              title: "Login Screen",
              child: LoginScreen(),
            ),
          );
        }),
    GetPage(
      name: '/register',
      page: () {
        return CustomRoutes(
          widget: DashboardScreen(),
          secondWidget: AuthScreen(
            title: 'Register Screen',
            child: RegisterScreen(),
          ),
        );
      },
    ),
    GetPage(
      name: '/test',
      page: () => AuthScreen(
        title: 'Table Data Patient',
        child: TableDataPatient(),
      ),
    ),
    GetPage(
      name: '/test1',
      page: () => AuthScreen(
        title: 'Register Patient',
        child: RegisterPatient(),
      ),
    ),
  ];
}

class CustomRoutes extends StatelessWidget {
  const CustomRoutes({
    super.key,
    required this.widget,
    required this.secondWidget,
  });
  final Widget widget;
  final Widget secondWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _isUserLogin.checkAuthState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              _isUserLogin.checkIsUserLogin(snapshot.data!.uid);
            }
            return Obx(() => AnimatedCrossFade(
                  layoutBuilder: (
                    topChild,
                    topChildKey,
                    bottomChild,
                    bottomChildKey,
                  ) =>
                      topChild,
                  firstChild: secondWidget,
                  secondChild: widget,
                  crossFadeState: !_isUserLogin.userIsLogin.value
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 1000),
                ));
          }
        });
  }
}
