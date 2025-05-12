import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/homeController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext   context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(controller.focusedDay.value),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Text(
              "Welcome Mr.GoJo",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        )),
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
          tabs: const [
            Tab(text: "Week"),
            Tab(text: "Month"),
          ],
          onTap: controller.changeCalendarFormat,
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildCalendarView(),
          _buildCalendarView(),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: controller.focusedDay.value,
            calendarFormat: controller.calendarFormat.value,
            selectedDayPredicate: (day) =>
                isSameDay(controller.selectedDay.value, day),
            onDaySelected: controller.onDaySelected,
            onPageChanged: controller.onPageChanged,
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.black87),
              defaultTextStyle: TextStyle(color: Colors.black87),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
              rightChevronIcon:
              Icon(Icons.chevron_right, color: Colors.blue),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final hasTask = controller.tasksByDate.keys.any(
                      (taskDate) => isSameDay(taskDate, day),
                );
                if (hasTask) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }
                return null;
              },
            ),
          )),
          const Divider(height: 1),
          _buildTaskView(),
        ],
      ),
    );
  }

  Widget _buildTaskView() {
    return Obx(() {
      final tasks = controller.tasksForSelectedDay;

      if (tasks.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "No tasks for this day.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tasks on ${DateFormat('MMMM d, yyyy').format(controller.selectedDay.value)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...tasks.map(
                  (task) => _buildTaskCard(
                title: task.title,
                time: task.time,
                color: task.color,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTaskCard({
    required String title,
    required String time,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
