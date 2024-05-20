import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  const CustomChoiceChip({
    super.key,
    this.fontsize,
    required this.content,
    required this.selected,
    required this.onSelected,
    this.titlefontzise,
  });
  final double? titlefontzise;
  final String content;
  final void Function(bool)? onSelected;
  final bool selected;
  final double? fontsize;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        content,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontsize,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
    );
    // return Column(
    //   children: <Widget>[
    //     Text(title,
    //         style: TextStyle(
    //             fontWeight: FontWeight.bold, fontSize: titlefontzise)),
    //     Wrap(
    //       spacing: 2.0,
    //       children: List<Widget>.generate(
    //         length,
    //         (int index) {
    //           return ChoiceChip(
    //             label: Text(
    //               content[index],
    //               style: TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: fontsize,
    //               ),
    //             ),
    //             selected: selected == index,
    //             onSelected: (bool selected) {
    //               onSelected(selected, index);
    //             },
    //           );
    //         },
    //       ).toList(),
    //     ),
    //   ],
    // );
  }
}
