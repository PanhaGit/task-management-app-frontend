import 'package:flutter/material.dart';

import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/controllers/homeController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final AuthControllers authController = Get.find<AuthControllers>();

  HomeScreen({super.key});

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedStatusIndex = 0;
  bool showElectricityDashboard = false;
  bool showDataUsageDashboard = false;

  final List<Map<String, dynamic>> statuses = [
    {'label': 'Draft', 'count': 5},
    {'label': 'Ongoing', 'count': 3},
    {'label': 'Completed', 'count': 48},
    {'label': 'Canceled', 'count': 2},
  ];

  final List<Map<String, String>> recentNotes = [
    {'title': 'Release Notes', 'subtitle': 'In PRD - Notes'},
    {'title': 'Meeting Recap', 'subtitle': 'Sprint Planning'},
    {'title': 'Bug Fixes', 'subtitle': 'UI Module'},
    {'title': 'Client Feedback', 'subtitle': 'Design Review'},
    {'title': 'Next Steps', 'subtitle': 'Product Strategy'},
  ];

  List<bool> selectedNotes = List.generate(5, (_) => false);
  bool get allSelected => selectedNotes.every((element) => element);
  bool get showRecentNotes => selectedStatusIndex != 0 && !showElectricityDashboard && !showDataUsageDashboard;

  bool isEditingProfile = false;
  TextEditingController profileController =
      TextEditingController(text: 'Tho Panha');

  void toggleAllNotes() {
    setState(() {
      bool newValue = !allSelected;
      selectedNotes = List.generate(selectedNotes.length, (_) => newValue);
    });
  }

  Widget _buildElectricityDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Welcome ",

              'Usage Electric',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  showElectricityDashboard = false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Bar chart
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MWh',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(550, '01'),
                    _buildBar(400, '02'),
                    _buildBar(300, '03'),
                    _buildBar(200, '04'),
                    _buildBar(100, '05'),
                    _buildBar(70, '06'),
                    _buildBar(50, '07'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Usage summary
        const Text(
          'Usage electric',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildUsageCard('Solar', '24.5 kWh', Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildUsageCard('The Mode', '85.5 kWh', Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Device details
        const Text(
          'Detail device',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDeviceDetail('Air Conditioner', 'At the 21st/6 kWh usage'),
        const SizedBox(height: 8),
        _buildDeviceDetail('TV Smart', 'On the 21st/3 kWh usage'),
      ],
    );
  }

  // Rest of your existing methods (_buildCalendarView, _buildTaskView, _buildTaskCard) remain unchanged
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

  Widget _buildDataUsageDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Data Usage',
              style: TextStyle(

                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  showDataUsageDashboard = false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Month selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('Mar', style: TextStyle(color: Colors.grey)),
            Text('Apr', style: TextStyle(color: Colors.grey)),
            Text('May', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Jun', style: TextStyle(color: Colors.grey)),
            Text('Jul', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        
        // Total data usage
        Center(
          child: Text(
            '5.03GB',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Daily data header
        const Text(
          'Daily Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Daily data list
        Column(
          children: [
            _buildDailyDataItem('Today', '542.13MB'),
            _buildDailyDataItem('14th', '854.27MB'),
            _buildDailyDataItem('13th', '724.65MB'),
            _buildDailyDataItem('12th', '782.34MB'),
            _buildDailyDataItem('11th', '1.03GB'),
            _buildDailyDataItem('10th', '638.92MB'),
            _buildDailyDataItem('9th', '842.63MB'),
          ],
        ),
        const SizedBox(height: 16),
        
        // Disclaimer
        const Text(
          'The above results are for reference only',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyDataItem(String day, String usage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            usage,
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height / 5, // Scale down to fit in the container
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildUsageCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceDetail(String device, String usage) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.electrical_services, color: Colors.blue[800]),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                usage,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting & Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: isEditingProfile
                          ? TextField(
                              controller: profileController,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            )
                          : Text(
                              'Hello,\n${profileController.text} 👋',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isEditingProfile ? Icons.check : Icons.edit,
                          ),
                          onPressed: () {
                            setState(() {
                              isEditingProfile = !isEditingProfile;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.star_border),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Click to search',
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (!showElectricityDashboard && !showDataUsageDashboard) ...[
                  // My works label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'My works',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.more_vert),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status Chips
                  Row(
                    children: List.generate(statuses.length, (index) {
                      final item = statuses[index];
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStatusIndex = index;
                              });
                            },
                            child: _StatusChip(
                              count: item['count'],
                              label: item['label'],
                              selected: selectedStatusIndex == index,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Task Cards
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showElectricityDashboard = true;
                              showDataUsageDashboard = false;
                            });
                          },
                          child: _TaskCard(
                            color: const Color(0xFFFDEBFB),
                            icon: Icons.bar_chart,
                            title: 'Advertising',
                            subtitle: 'Marketing',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showDataUsageDashboard = true;
                              showElectricityDashboard = false;
                            });
                          },
                          child: _TaskCard(
                            color: const Color(0xFFE4F2FD),
                            icon: Icons.business_center,
                            title: 'Presentations',
                            subtitle: 'Sales',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],

                if (showElectricityDashboard) 
                  _buildElectricityDashboard(),
                
                if (showDataUsageDashboard)
                  _buildDataUsageDashboard(),

                // Recent Notes Header
                if (showRecentNotes) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Notes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: toggleAllNotes,
                        child: Text(
                          allSelected ? 'Unselect All' : 'Select All',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Profile-style Recent Notes
                  Column(
                    children: List.generate(recentNotes.length, (index) {
                      final note = recentNotes[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selectedNotes[index]
                              ? Colors.blue[50]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade200,
                              child: Text(
                                note['title']![0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Title & Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    note['subtitle']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Checkbox
                            Checkbox(
                              value: selectedNotes[index],
                              onChanged: (value) {
                                setState(() {
                                  selectedNotes[index] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Status Chip Widget
class _StatusChip extends StatelessWidget {
  final int count;
  final String label;
  final bool selected;

  const _StatusChip({
    required this.count,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? Colors.blue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? Colors.blue : Colors.grey.shade300,
          width: selected ? 3 : 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: selected ? Colors.blue : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: selected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Task Card Widget
class _TaskCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _TaskCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}