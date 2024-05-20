import 'package:flutter/material.dart';
// import 'package:flutter_absensi/helpers/protected/history_helper.dart';
import 'package:flutter_absensi/helpers/protected/signin_signout_helper.dart';
import 'package:flutter_absensi/widget/custom_button/custom_filled_button.dart';
import 'package:flutter_absensi/widget/custom_card/custom_card.dart';
import 'package:flutter_absensi/widget/custom_choice_chip/custom_choice_chip.dart';
import 'package:flutter_absensi/widget/custom_textfromfield/custom_textformfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SigninSignout extends StatelessWidget {
  SigninSignout({super.key});

  final SigninSignOutHelper _controller = Get.put(SigninSignOutHelper());
  // final HistoryHelper _ = Get.put(HistoryHelper());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: CustomFilledButton(
                  label: "Check In",
                  onPressed: !_controller.isCheckIn.value
                      ? () => _controller.handleTimechange("Check In", context)
                      : null,
                ),
              ),
              Flexible(
                child: CustomFilledButton(
                  label: "Check Out",
                  onPressed: !_controller.isCheckOut.value
                      ? () => _controller.handleTimechange("Check Out", context)
                      : null,
                ),
              ),
            ],
          ),
          Flexible(
            child: CustomFilledButton(
              label: "Lain-Nya",
              onPressed:
                  !_controller.isCheckIn.value && !_controller.isCheckOut.value
                      ? () => showAlasan(context)
                      : null,
            ),
          ),
          AnimatedCrossFade(
              firstChild: mobileScreen(),
              secondChild: desktopScreen(),
              crossFadeState: MediaQuery.of(context).size.width > 700
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 500)),
        ],
      ),
    );
  }

  Widget mobileScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CustomCardWithHeader(
            header: "Checkin",
            children: Column(
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
        Flexible(
          child: CustomCardWithHeader(
            header: "Checkout",
            children: Column(
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
        Flexible(
          child: CustomCardWithHeader(
            isGap: false,
            header: "Lain-Nya",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _controller.status.value.capitalize!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(5.0),
                    Text(
                      _controller.valueAlasan.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget desktopScreen() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: CustomCardWithHeader(
            header: "Checkin",
            children: Column(
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
        Flexible(
          child: CustomCardWithHeader(
            header: "Checkout",
            children: Column(
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
        Flexible(
          child: CustomCardWithHeader(
            isGap: false,
            header: "Lain-Nya",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _controller.status.value.capitalize!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(5.0),
                    Text(
                      _controller.valueAlasan.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> showAlasan(BuildContext context) {
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
                  Obx(
                    () => CustomChoiceChip(
                      title: 'Alasan',
                      content: const ["Sakit", "Ijin"],
                      length: 2,
                      selected: _controller.value.value,
                      onSelected: _controller.handleChange(false, 1),
                    ),
                  ),
                  const Gap(10.0),
                  Obx(() => _controller.value.value == 1
                      ? CustomTextFormField(
                          label: "Alasan",
                          verification: true,
                          maxlines: 3,
                          keyboardType: TextInputType.multiline,
                          onSave: (value) => _controller.handleAlasan(value),
                        )
                      : const Flexible(child: Text(""))),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomFilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: "Submit",
              ),
            ),
          ],
        );
      },
    );
  }
}
