import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/helpers/protected/signin_signout_helper.dart';
import 'package:flutter_praktek_dokter/widget/custom_button/custom__text_button.dart';
import 'package:flutter_praktek_dokter/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_praktek_dokter/widget/custom_choice_chip/custom_choice_chip.dart';
import 'package:flutter_praktek_dokter/widget/custom_textfromfield/custom_textformfield.dart';
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
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomFilledButton(
                    label: "Check in",
                    onPressed: () async => print(
                        await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high)),
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