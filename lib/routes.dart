import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/auth/auth_helper.dart';
import 'package:flutter_absensi/screens/auth/auth_screen.dart';
import 'package:flutter_absensi/screens/auth/login.dart';
import 'package:flutter_absensi/screens/protected/Register/register_place.dart';
import 'package:flutter_absensi/screens/protected/Table/table_place.dart';
import 'package:flutter_absensi/screens/protected/dashboard/dashboard_screen.dart';
import 'package:flutter_absensi/screens/protected/protected_screen.dart';
import 'package:flutter_absensi/screens/protected/signin_signout/signin_signout.dart';
import 'package:get/get.dart';

final AuthHelper _isUserLogin = Get.put(AuthHelper());

class Routes {
  List<GetPage<dynamic>> routes = [
    GetPage(
        name: '/',
        page: () {
          return CustomRoutes(
            widget: DashboardScreen(
              child: ProtectedScreen(
                title: "Dashboard",
                child: SigninSignout(),
              ),
            ),
            secondWidget: const AuthScreen(
              title: "Login Screen",
              child: LoginScreen(),
            ),
          );
        }),
    GetPage(
      name: '/register',
      page: () {
        return CustomRoutes(
          widget: DashboardScreen(
            child: ProtectedScreen(title: "Dashboard", child: SigninSignout()),
          ),
          secondWidget: const AuthScreen(
            title: 'Register Screen',
            child: LoginScreen(),
          ),
        );
      },
    ),
    GetPage(
      name: '/test',
      page: () {
        return CustomRoutes(
          widget: DashboardScreen(
            child: ProtectedScreen(title: "Dashbaord", child: TablePlace()),
          ),
          secondWidget: const AuthScreen(
            title: 'Register Screen',
            child: Text("Null"),
          ),
        );
      },
    ),
    GetPage(
      name: '/test1',
      page: () {
        return CustomRoutes(
          widget: DashboardScreen(
            child: ProtectedScreen(title: "Dashbaord", child: RegisterPlace()),
          ),
          secondWidget: const AuthScreen(
            title: 'Register Screen',
            child: Text("Null"),
          ),
        );
      },
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
