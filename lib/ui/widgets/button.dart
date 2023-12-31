import 'package:flutter/material.dart';
import 'package:tasks/ui/ui.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Themes.primaryClr),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
