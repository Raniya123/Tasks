import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          child: Text("$label"),
        ));
  }
}
