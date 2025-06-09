import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/category_controller.dart';
import 'package:frontend_app_task/controllers/home_controller.dart';
import 'package:frontend_app_task/models/Task.dart';
import 'package:frontend_app_task/util/format_date_helper.dart';
import 'package:frontend_app_task/util/helper/helper.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final FormatDateHelper formatDateHelper = FormatDateHelper();
  final HomeController homeController = Get.find<HomeController>();
  final TextEditingController _categoryNameController = TextEditingController();
  final CategoryController _categoryController = Get.find<CategoryController>();
  final Rx<Color> currentColor = Rx<Color>(Colors.blue); // Default color

  @override
  void initState() {
    super.initState();
    // Sync initial color with controller after API call
    _categoryController.getAllColor().then((_) {
      if (_categoryController.categoryColor.isNotEmpty) {
        currentColor.value = Color(
            int.parse(_categoryController.categoryColor[0].hex.replaceFirst('#', '0xff')));
        _categoryController
            .changeSelectedColor(_categoryController.categoryColor[0].hex);
      }
    });
  }

  void changeColor(Color color) {
    currentColor.value = color;
    _categoryController.changeSelectedColor(
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
    );
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  bool _hasTasks(DateTime date) {
    return homeController.tasks.any((task) =>
    (task.startDate != null && isSameDay(task.startDate, date)) ||
        (task.endDate != null && isSameDay(task.endDate, date)));
  }

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
    _categoryNameController.dispose();
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.pink.withOpacity(.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                color: AppColors.pink,
                iconSize: 30,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => _addCategory(),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ],
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

  Widget _tableCalenderDate() {
    return Card(
      elevation: 0,
      color: AppColors.white,
      child: TableCalendar(
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            if (day.weekday == DateTime.sunday) {
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
                border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
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

  Widget _buildTimelineTile() {
    final tasksToShow = _getTasksForSelectedDate();

    if (tasksToShow.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "No tasks available",
            style: TextStyle(color: Colors.grey),
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
          beforeLineStyle: const LineStyle(
            color: AppColors.brightSkyBlue,
            thickness: 2,
          ),
          afterLineStyle: const LineStyle(
            color: AppColors.brightSkyBlue,
            thickness: 2,
          ),
          indicatorStyle: IndicatorStyle(
            width: 40,
            height: 40,
            color: AppColors.brightSkyBlue,
            padding: const EdgeInsets.all(4),
            indicator: Container(
              decoration: const BoxDecoration(
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

  Widget _addCategory() {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Calendar Category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _colorUserCanSelect(),
            const SizedBox(height: 20),
            Obx(() => CustomButtonWidget(
              backgroundColor: AppColors.azureBlue,
              textColor: AppColors.white,
              buttonText: _categoryController.isLoadingCategories.value
                  ? "Saving..."
                  : "Save",
              onPressed: _categoryController.isLoadingCategories.value
                  ? null
                  : () async {
                if (_categoryNameController.text.trim().isNotEmpty) {
                  final payload = {
                    'title': _categoryNameController.text.trim(),
                    'color': _categoryController.selectedColorHex.value,
                  };
                  await _categoryController.storeCategory(payload);
                  if (!_categoryController.isLoadingCategories.value) {
                    _categoryNameController.clear();
                    currentColor.value = Colors.blue; // Reset color
                    _categoryController.changeSelectedColor(
                        _categoryController.categoryColor.isNotEmpty
                            ? _categoryController.categoryColor[0].hex
                            : '#0000FF');
                    Navigator.of(context).pop();
                  }
                } else {
                  Get.snackbar('Error', 'Please enter a category name',
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
            ).buildButton()),
          ],
        ),
      ),
    );
  }

  Widget _colorUserCanSelect() {
    return Obx(() {
      final isLoading = _categoryController.isLoadingCategories.value;
      final colors = _categoryController.categoryColor;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Color",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const Text(
              "Loading colors...",
              style: TextStyle(color: Colors.grey),
            )
          else if (colors.isEmpty)
            const Text(
              "No colors available",
              style: TextStyle(color: Colors.grey),
            )
          else
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(colors.length, (index) {
                final color = colors[index];
                final colorValue =
                Color(int.parse(color.hex.replaceFirst('#', '0xff')));
                final isSelected =
                    _categoryController.selectedColorHex.value == color.hex;

                return GestureDetector(
                  onTap: () {
                    changeColor(colorValue);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        color.name,
                        style:
                        const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.check,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColors.white,
                    title: const Text('Pick a Custom Color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: currentColor.value,
                        onColorChanged: changeColor,
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Done'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: currentColor.value,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Custom',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}