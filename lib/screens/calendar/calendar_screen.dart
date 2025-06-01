/***
 * Calendar Screen
 *
 * This screen displays a calendar view with tasks timeline.
 * Users can select dates to view tasks for specific days.
 *
 * Features:
 * - Interactive calendar with task indicators
 * - Timeline view of tasks
 * - Date-based task filtering
 * - Pull-to-refresh functionality
 *
 * @author Tho Panha
 */

import 'package:flutter/material.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/home_controller.dart';
import 'package:frontend_app_task/models/Task.dart';
import 'package:frontend_app_task/util/format_date_helper.dart';
import 'package:frontend_app_task/util/helper/helper.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // State variables
  DateTime? _selectedDay; // Currently selected day
  DateTime _focusedDay = DateTime.now(); // Currently focused day in calendar
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final formatDateHelper = FormatDateHelper(); // Date formatting helper
  final HomeController homeController = Get.find<HomeController>(); // Task controller

  /***
   * Handle refresh action
   * Simulates data refresh with 1 second delay
   */
  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  /***
   * Check if a date has any tasks
   * @param date - The date to check
   * @return bool - True if date has tasks
   */
  bool _hasTasks(DateTime date) {
    return homeController.tasks.any((task) =>
    (task.startDate != null && isSameDay(task.startDate, date)) ||
        (task.endDate != null && isSameDay(task.endDate, date))
    );
  }

  /***
   * Get tasks for the currently selected date
   * @return List<Task> - Filtered task list
   */
  List<Task> _getTasksForSelectedDate() {
    if (_selectedDay == null) return homeController.tasks;

    return homeController.tasks.where((task) {
      return isSameDay(task.startDate, _selectedDay) ||
          isSameDay(task.endDate, _selectedDay);
    }).toList();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundGradient(
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              enablePullDown: true,
              enablePullUp: false,
              header: const ClassicHeader(
                completeText: "Refresh completed",
                refreshingText: "Refreshing...",
                releaseText: "Release to refresh",
                idleText: "Pull down to refresh",
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _tableCalenderDate(),
                        const SizedBox(height: 20),
                        _buildTimelineTile(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /***
   * Build the calendar widget
   * @return Widget - Calendar component
   */
  Widget _tableCalenderDate() {
    return Card(
      elevation: 0,
      color: AppColors.white,
      child: TableCalendar(
        calendarBuilders: CalendarBuilders(
          // Customize day of day headers
          dowBuilder: (context, day) {
            if (day.day == DateTime.sunday) {
              final text = DateFormat.E().format(day);
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return null;
          },
          // Customize day cells
          defaultBuilder: (context, day, focusedDay) {
            final hasTasks = _hasTasks(day);
            final isSelected = isSameDay(_selectedDay, day);
            final isToday = isSameDay(day, DateTime.now());

            Color? backgroundColor;
            if (isSelected) {
              backgroundColor = AppColors.brightSkyBlue;
            } else if (hasTasks) {
              backgroundColor = Colors.blue.withOpacity(0.3);
            }

            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isToday
                        ? Colors.orangeAccent
                        : day.weekday == DateTime.sunday
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: CalendarFormat.week,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left),
          rightChevronIcon: Icon(Icons.chevron_right),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: AppColors.brightSkyBlue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: const TextStyle(color: Colors.red),
        ),
        availableGestures: AvailableGestures.all,
      ),
    );
  }

  /***
   * Build the timeline of tasks
   * @return Widget - Timeline component
   */
  Widget _buildTimelineTile() {
    final tasksToShow = _getTasksForSelectedDate();

    // Show empty state if no tasks
    if (tasksToShow.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            _selectedDay == null
                ? "No tasks available"
                : "No tasks for selected date",
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }



    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasksToShow.length,
      itemBuilder: (context, index) {
        final task = tasksToShow[index];
        final categoryColor = Color(Helper.getColorFromHex(task.categories.color));



        return TimelineTile(
          alignment: TimelineAlign.start,
          lineXY: 0.2,
          isFirst: index == 0,
          isLast: index == tasksToShow.length - 1,
          beforeLineStyle: LineStyle(
            color: AppColors.brightSkyBlue,
            thickness: 2,
          ),
          afterLineStyle: LineStyle(
            color: AppColors.brightSkyBlue,
            thickness: 2,
          ),
          indicatorStyle: IndicatorStyle(
            width: 40,
            height: 40,
            color: AppColors.brightSkyBlue,
            padding: const EdgeInsets.all(4),
            indicator: Container(
              decoration: BoxDecoration(
                color: AppColors.brightSkyBlue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "${formatDateHelper.formatTimeTask(task.endDate)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
          endChild: Card(
            color: AppColors.white,
            margin: const EdgeInsets.only(bottom: 16, left: 8),
            elevation: 0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border(
                  left: BorderSide(
                    color: categoryColor,
                    width: 3.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          "${formatDateHelper.formatMonthAndYear(task.endDate)} ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
