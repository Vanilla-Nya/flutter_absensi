import 'package:flutter/material.dart';

class CustomFlatTextButton extends StatelessWidget {
  const CustomFlatTextButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isDisabled = false,
  });

  final Widget child;
  final void Function()? onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.transparent;
          }
          return Colors.transparent;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (isDisabled) {
            return Colors.grey;
          } else {
            if (states.contains(MaterialState.hovered)) {
              return Theme.of(context).colorScheme.onPrimaryContainer;
            }
            return Theme.of(context).colorScheme.tertiary;
          }
        }),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
