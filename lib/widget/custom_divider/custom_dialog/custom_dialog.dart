import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.constraints,
    required this.content,
    required this.actions,
  });
  final String title;
  final BoxConstraints constraints;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: constraints,
        child: content,
      ),
      actions: actions,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
