import 'package:flutter/material.dart';
import 'package:flutter_absensi/helpers/protected/signin_signout_helper.dart';
import 'package:flutter_absensi/models/map/geodencing.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_card/custom_card.dart';
import 'package:flutter_absensi/widget/custom_choice_chip/custom_choice_chip.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SigninSignout extends StatelessWidget {
  SigninSignout({super.key});
  final SigninSignOutHelper _controller = Get.put(SigninSignOutHelper());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: CustomFilledButton(
                  label: "Check in",
                  onPressed: () async {
                    final bool isInside = await const GeoFencing.square(
                        listSquareGeoFencing: <SquareGeoFencing>[
                          SquareGeoFencing(
                            id: "Puskesmas Sumber Wringin",
                            latitudeStart: -7.9791797,
                            latitudeEnd: -7.979752,
                            longitudeStart: 113.9933635,
                            longitudeEnd: 113.9936065,
                          ),
                        ]).isInsideSquareGeoFencing();

                    if (!isInside) {
                      Get.snackbar("Outside", "");
                      if (!context.mounted) return;
                      return showModalBottomSheet(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                          minHeight: MediaQuery.of(context).size.height * 0.5,
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
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
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: CustomFilledButton(
                                  onPressed: () {},
                                  label: "Submit",
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Position position = await Geolocator.getCurrentPosition();
                      print(position);
                      Get.snackbar("Inside", "");
                    }
                  },
                ),
              ),
              Flexible(
                child: CustomFilledButton(
                    label: "Lain-Nya",
                    onPressed: () => showModalBottomSheet(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                            minHeight: MediaQuery.of(context).size.height * 0.5,
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
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
            child: Obx(
              () => _controller.isCheckIn.value
                  ? CustomFilledButton(
                      label: "Check Out",
                      onPressed: () => _controller.handleTimechangeOut(),
                    )
                  : CustomFilledButton(
                      label: "Check in",
                      onPressed: () => _controller.handleTimechange(),
                    ),
            ),
          ),
          CustomCardWithHeader(
            header: "Checkin",
            children: SizedBox(
              child: Column(
                children: [
                  Obx(
                    () => Text(
                      _controller.datetimeIN.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomCardWithHeader(
            header: "Checkout",
            children: SizedBox(
              child: Column(
                children: [
                  Obx(
                    () => Text(
                      _controller.datetimeOut.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomCardWithHeader(
            header: "Lain-Nya",
            children: SizedBox(
              child: Column(
                children: [
                  Obx(
                    () => Text(
                      _controller.status.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
