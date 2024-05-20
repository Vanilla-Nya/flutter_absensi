import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  const CustomChoiceChip({
    super.key,
    required this.title,
    this.fontsize,
    required this.content,
    required this.length,
    this.selected,
    required this.onSelected,
    this.titlefontzise,
  });
  final String title;
  final double? titlefontzise;
  final List<String> content;
  final int length;
  final void Function(bool, int) onSelected;
  final int? selected;
  final double? fontsize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: titlefontzise)),
        Wrap(
          spacing: 2.0,
          children: List<Widget>.generate(
            length,
            (int index) {
              return ChoiceChip(
                label: Text(
                  content[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontsize,
                  ),
                ),
                selected: selected == index,
                onSelected: (bool selected) => onSelected(selected, index),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
