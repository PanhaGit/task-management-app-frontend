import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class Task {
  final String title;
  final String time;
  final Color color;

  Task({required this.title, required this.time, required this.color});
}

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  var calendarFormat = CalendarFormat.week.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;

  // Normalize to remove time
  DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);

  // Tasks by normalized date
  final Map<DateTime, List<Task>> tasksByDate = {
    DateTime(2025, 5, 12): [
      Task(title: "Team Meeting", time: "10:00 AM", color: Colors.teal),
      Task(title: "Project Review", time: "3:00 PM", color: Colors.blue),
    ],
    DateTime(2025, 5, 14): [
      Task(title: "Design Review", time: "1:00 PM", color: Colors.green),
    ],
  };

  List<Task> get tasksForSelectedDay =>
      tasksByDate[_normalize(selectedDay.value)] ?? [];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    selectedDay.value = _normalize(DateTime.now());
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void changeCalendarFormat(int index) {
    calendarFormat.value = index == 0 ? CalendarFormat.week : CalendarFormat.month;
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = _normalize(selected);
    focusedDay.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
  }
}
