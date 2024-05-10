import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/helpers/protected/signin_signout_helper.dart';
import 'package:get/get.dart';

class CustomChoiceChip extends StatelessWidget {
  CustomChoiceChip({
    super.key,
    required this.title,
    required this.content,
    required this.length,
    this.onSelected,
    this.fontsize,
  });
  final String title;
  final List<String> content;
  final int length;
  final void Function(bool)? onSelected;
  final SigninSignOutHelper _controller = Get.put(SigninSignOutHelper());
  final double? fontsize;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Text(title, style: textTheme.labelLarge),
        Wrap(
          spacing: 2.0,
          children: List<Widget>.generate(
            length,
            (int index) {
              return Obx(() => ChoiceChip(
                    label: Text(
                      content[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      ),
                    ),
                    selected: _controller.value.value == index,
                    onSelected: (bool selected) =>
                        _controller.handleChange(selected, index),
                  ));
            },
          ).toList(),
        ),
      ],
    );
  }
}
