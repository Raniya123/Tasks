import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/task_controller.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/ui/ui.dart';

// to convert from statelesswidget to StatefulWidget in VScode use cmd + .
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _noteEditingController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  int _selectedReminder = 5;
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  List<int> reminderList = [5, 10, 15, 20];
  String _selectedRepear = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
        appBar: _appBar(context),
        body: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Task",
                    style: headingStyle,
                  ),
                  TaskInputField(
                    title: "Title",
                    hint: "Enter title here.",
                    controller: _textEditingController,
                  ),
                  TaskInputField(
                    title: "Note",
                    hint: "Enter note here.",
                    controller: _noteEditingController,
                  ),
                  TaskInputField(
                    title: "Date",
                    hint: DateFormat.yMd().format(_selectedDate),
                    widget: IconButton(
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _getDateFromUser(context);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TaskInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _getTimeFromUser(
                                isStartTime: true, context: context);
                          },
                        ),
                      )),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: TaskInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _getTimeFromUser(
                                isStartTime: false, context: context);
                          },
                        ),
                      ))
                    ],
                  ),
                  TaskInputField(
                    title: "Remind",
                    hint: "$_selectedReminder minutes early",
                    widget: DropdownButton(
                      underline: Container(
                        height: 0,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedReminder = int.parse(value!);
                        });
                      },
                      style: subTitleStyle,
                      items: reminderList
                          .map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TaskInputField(
                    title: "Repeat",
                    hint: "$_selectedRepear",
                    widget: DropdownButton(
                      underline: Container(
                        height: 0,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRepear = value!;
                        });
                      },
                      style: subTitleStyle,
                      items: repeatList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _colorPallete(),
                        MyButton(
                            label: "Create Task", onTap: () => _validateData())
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        Wrap(
          children: List<Widget>.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0, top: 4),
                      child: CircleAvatar(
                        // ignore: sort_child_properties_last
                        child: _selectedColor == index
                            ? const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 16,
                              )
                            : Container(),
                        radius: 14,
                        backgroundColor: index == 0
                            ? Themes.bluisClr
                            : index == 1
                                ? Themes.pinkClr
                                : Themes.yellowClr,
                      ),
                    ),
                  )),
        )
      ],
    );
  }

  _getTimeFromUser(
      {required bool isStartTime, required BuildContext context}) async {
    var pickedTime = await _showTimePicker(isStartTime: isStartTime);
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
    } else if (isStartTime) {
      setState(() {
        _startTime = formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = formatedTime;
      });
    }
  }

  _showTimePicker({required bool isStartTime}) async {
    return await showTimePicker(
        builder: (context, child) {
          return Theme(
            data: Get.isDarkMode
                ? ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      // change the border color
                      primary: Themes.primaryClr,
                      // change the text color
                      onSurface: Themes.pinkClr,
                    ),
                    // button colors
                    buttonTheme: const ButtonThemeData(
                      colorScheme: ColorScheme.light(
                        primary: Colors.green,
                      ),
                    ),
                  )
                : ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      // change the border color
                      primary: Themes.primaryClr,
                      // change the text color
                      onSurface: Themes.pinkClr,
                    ),
                    // button colors
                    buttonTheme: const ButtonThemeData(
                      colorScheme: ColorScheme.light(
                        primary: Colors.green,
                      ),
                    ),
                  ),
            child: child!,
          );
        },
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
        initialEntryMode: TimePickerEntryMode.input);
  }

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Get.isDarkMode
                ? ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      // change the border color
                      primary: Themes.primaryClr,
                      // change the text color
                      onSurface: Themes.pinkClr,
                    ),
                    // button colors
                    buttonTheme: const ButtonThemeData(
                      colorScheme: ColorScheme.light(
                        primary: Colors.green,
                      ),
                    ),
                  )
                : ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      // change the border color
                      primary: Themes.primaryClr,
                      // change the text color
                      onSurface: Themes.pinkClr,
                    ),
                    // button colors
                    buttonTheme: const ButtonThemeData(
                      colorScheme: ColorScheme.light(
                        primary: Colors.green,
                      ),
                    ),
                  ),
            child: child!,
          );
        },
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      // ignore: avoid_print
      print("it's null or somthing is wrong");
    }
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.jpeg"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _addTaskToDb() async {
    try {
      await _taskController.addTask(
          task: Task(
        note: _noteEditingController.text,
        title: _textEditingController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedReminder,
        repeat: _selectedRepear,
        color: _selectedColor,
        isCompleted: 0,
      ));
    } catch (e) {
      rethrow;
    }
  }

  _validateData() {
    if (_textEditingController.text.isNotEmpty &&
        _noteEditingController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_textEditingController.text.isEmpty ||
        _noteEditingController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ));
    }
  }
}
