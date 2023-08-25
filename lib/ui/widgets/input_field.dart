import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/ui/ui.dart';

class TaskInputField extends StatelessWidget {
  final String title;
  final String? hint;
  final TextEditingController? controller;
  final Widget? widget;
  const TaskInputField(
      {Key? key, required this.title, this.hint, this.controller, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52,
            //  color: Colors.grey,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: (widget != null),
                    autofocus: false,
                    controller: controller,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
                    style: subTitleStyle,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.colorScheme.background,
                                width: 0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.colorScheme.background,
                                width: 0))),
                  ),
                ),
                if (widget != null)
                  Container(
                    child: widget,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
