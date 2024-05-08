import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/helpers/protected/signin_signout_helper.dart';
import 'package:flutter_praktek_dokter/widget/custom_button/custom__text_button.dart';
import 'package:flutter_praktek_dokter/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_praktek_dokter/widget/custom_choice_chip/custom_choice_chip.dart';
import 'package:flutter_praktek_dokter/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:gap/gap.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SigninSignout extends StatelessWidget {
  SigninSignout({super.key});
  final SigninSignOutHelper _controller = Get.put(SigninSignOutHelper());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomFilledButton(
                    label: "Check in",
                    onPressed: () async {
                      Position position = await Geolocator.getCurrentPosition();
                      final _geofenceStreamController =
                          StreamController<Geofence>();
                      // bool isInGeoFence = GeoFencingManager.isGeoFenceWithinRadius(
                      //   center: LatLng(-7.9792717, 113.9933517),
                      //   radius: 50.0,
                      //   id: "workplace",
                      //   latitude: position.latitude,
                      //   longitude: position.longitude,
                      // );
                      final geofenceService = GeofenceService.instance.setup();
                      final geofenceList = <Geofence>[
                        Geofence(
                          id: "workplace",
                          latitude: -7.9792717,
                          longitude: 113.9933517,
                          radius: [
                            GeofenceRadius(id: "radius_50_m", length: 50),
                          ],
                        ),
                      ];
                      geofenceService
                          .start(geofenceList)
                          .catchError((error) => print(error));
                      // This function is to be called when the geofence status is changed.
                      Future<void> _onGeofenceStatusChanged(
                          Geofence geofence,
                          GeofenceRadius geofenceRadius,
                          GeofenceStatus geofenceStatus,
                          Location location) async {
                        print('geofence: ${geofence.toJson()}');
                        print('geofenceRadius: ${geofenceRadius.toJson()}');
                        print('geofenceStatus: ${geofenceStatus.toString()}');
                        _geofenceStreamController.sink.add(geofence);
                      }

                      geofenceService.addGeofenceStatusChangeListener(
                          _onGeofenceStatusChanged);
                    },
                  ),
                ),
                Flexible(
                  child: CustomFilledButton(
                      label: "Ijin",
                      onPressed: () => showModalBottomSheet(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Stack(
                                alignment: Alignment.center,
                                fit: StackFit.expand,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        CustomChoiceChip(
                                          title: 'Alasan',
                                          content: const ["Sakit", "Ijin"],
                                          length: 2,
                                        ),
                                        const Gap(10.0),
                                        Obx(() => _controller.value.value == 1
                                            ? CustomTextFormField(
                                                label: "Alasan",
                                                verification: true,
                                                maxlines: 3,
                                                keyboardType:
                                                    TextInputType.multiline,
                                              )
                                            : const Flexible(child: Text(""))),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: CustomFilledButton(
                                      onPressed: () {},
                                      label: "Submit",
                                    ),
                                  ),
                                ],
                              );
                            },
                          )),
                ),
              ],
            ),
            Flexible(
              child: CustomFilledButton(
                label: "Check out",
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
