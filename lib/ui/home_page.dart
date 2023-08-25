import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/task_controller.dart';
import 'package:tasks/services/notification_services.dart';
import 'package:tasks/services/theme_services.dart';
import 'package:tasks/ui/ui.dart';
import 'package:tasks/models/task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 20,
          ),
          _showTasks(context)
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Themes.bluisClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });

          //  _taskController.getTasks();
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
        margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subheadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
            MyButton(
                label: "+ Add Task",
                onTap: () async {
                  await Get.to(() => AddTaskPage());

                  _taskController.getTasks();
                })
          ],
        ));
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchtheme();
          notifyHelper.displayNotification(
            title: "Notify Theme Changed",
            body: !Get.isDarkMode ? "It's Dark mode!" : "It's Light Mode",
          );
          // notifyHelper.scheduledNotification();
        },
        // ignore: prefer_const_constructors
        child: Icon(
          !Get.isDarkMode ? Icons.nightlight_round : Icons.sunny,
          size: 20,
          color: Get.isDarkMode ? Colors.yellow : Colors.black,
        ),
      ),
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
        const CircleAvatar(
          backgroundImage: AssetImage("images/profile.jpeg"),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _showTasks(context) {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, indx) {
            Task task = _taskController.taskList[indx];
            if (task.repeat == "Daily") {
              DateTime date = DateFormat("hh:mm")
                  .parse(task.startTime!.split(" ")[0].toString());
              int covertedTimeStart;
              var myTime = DateFormat("HH:mm").format(date);

              if (task.startTime.toString().split(" ")[1] == "PM") {
                covertedTimeStart =
                    int.parse(myTime.toString().split(":")[0]) + 12;
              } else {
                covertedTimeStart = int.parse(myTime.toString().split(":")[0]);
              }

              notifyHelper.scheduledNotification(covertedTimeStart,
                  int.parse(myTime.toString().split(":")[1]), task);
              return AnimationConfiguration.staggeredList(
                  position: indx,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskCard(task),
                          )
                        ],
                      ),
                    ),
                  ));
            } else if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                  position: indx,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskCard(task),
                          )
                        ],
                      ),
                    ),
                  ));
            } else {
              return Container();
            }
          });
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      color: context.theme.primaryColor,
      padding: const EdgeInsets.only(top: 4),
      height: (task.isCompleted == 1)
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.30,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  context: context,
                  label: "Task Completed",
                  onTap: () {
                    _taskController.updateTask(task.id!);
                    _taskController.getTasks();
                    Get.back();
                  },
                  clr: Themes.bluisClr,
                ),
          _bottomSheetButton(
            context: context,
            label: "Delete Task",
            onTap: () {
              _taskController.delete(task.id!);
              _taskController.getTasks();
              Get.back();
            },
            clr: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
            context: context,
            label: "Cancel",
            onTap: () {
              Get.back();
            },
            clr: Colors.white,
            isClose: true,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required BuildContext context,
      required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        height: 55,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: isClose ? Colors.red : clr),
          borderRadius: BorderRadius.circular(10),
          color: clr,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 16, color: isClose ? Colors.red : Colors.white)),
          ),
        ),
      ),
    );
  }
}
