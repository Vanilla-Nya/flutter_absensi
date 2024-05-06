import 'package:flutter/material.dart';
import 'package:flutter_praktek_dokter/widget/custom_button/custom_filled_button.dart';

class SigninSignout extends StatelessWidget {
  const SigninSignout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CustomFilledButton(
                icon: const Icon(Icons.sign_language_outlined),
                label: "SignIN",
                onPressed: () => {},
              ),
            ),
            Flexible(
              child: CustomFilledButton(
                label: "SignOut",
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
