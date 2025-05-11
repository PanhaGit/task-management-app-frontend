import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime(DateTime.now().year, 6, 25); // Default to June 25
  int _currentWeekStart = 24; // Week starting at 24th

  void _selectDate(int day) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day);
    });
  }

  void _navigateWeek(int direction) {
    setState(() {
      _currentWeekStart += direction * 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('assets/images/laypicture.jpg'),
              radius: 16,
            ),
            onPressed: () {
              ;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date
              const Text(
                "Schedule",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${_getWeekday(_selectedDate.weekday)}, ${_selectedDate.day} ${_getMonthName(_selectedDate.month)}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Month list with navigation
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _navigateWeek(-1),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(12, (index) {
                          final month = DateTime(2023, index + 1, 1);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _getMonthName(month.month),
                              style: TextStyle(
                                fontWeight: month.month == _selectedDate.month
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _navigateWeek(1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar table
              Table(
                border: TableBorder.all(color: Colors.grey.withOpacity(0.2)),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("No")),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("Mon")),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("Tue")),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("Wed")),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("Thu")),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("Fri")),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("Sat")),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(child: Text("Sun")),
                      ),
                    ],
                  ),
                  TableRow(
                    children: List.generate(8, (index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(child: Text(_currentWeekStart.toString())),
                        );
                      }
                      
                      final day = _currentWeekStart + index - 1;
                      final isSelected = day == _selectedDate.day && 
                          _selectedDate.month == 6; // June
                      
                      return GestureDetector(
                        onTap: () => _selectDate(day),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: isSelected
                                ? CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 14,
                                    child: Text(
                                      day.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : Text(day.toString()),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Today's Timeline
              const Text(
                "Today's Timeline",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTimeSlot("08:00", "Morning Exercise"),
              _buildTimeSlot("01:00", "Lunch with Team"),
              _buildTimeSlot("02:00", "Project Review"),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Marketing Strategy
              const Text(
                "Marketing Strategy",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Linked Break",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTimeSlot("10:00", "Campaign Planning"),
              _buildTimeSlot("11:00", "Client Call"),
              _buildTimeSlot("12:00", "Social Media Review"),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Interview with Client
              const Text(
                "Interview with Client",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildEventCard("Design Meeting", Icons.design_services, Colors.purple),
              const SizedBox(height: 8),
              _buildEventCard("U Design Workshop", Icons.workspaces, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, String event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(
              time,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(event),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
               backgroundImage: NetworkImage('assets/images/photopanha.jpg'),
              ),
              const SizedBox(height: 16),
              const Text(
                "Lean Kimlay",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Product Designer",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Lean.kimlay@gmail.com"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("+1 (555) 123-4567"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {},
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}