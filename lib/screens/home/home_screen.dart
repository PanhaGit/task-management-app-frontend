import 'package:flutter/material.dart';

class Task {
  final String event;
  final String title;

  Task({required this.event, required this.title});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedButtonIndex = 0;
  final List<String> _filterButtons = ['All', 'Work', 'Personal', 'Family'];

  final Map<String, bool> _taskCompletionStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'April 2025',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Text(
              'Welcome Haley Champlin',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeekdayHeader(day: 'SUN'),
                _WeekdayHeader(day: 'MON'),
                _WeekdayHeader(day: 'TUE'),
                _WeekdayHeader(day: 'WED'),
                _WeekdayHeader(day: 'THU'),
                _WeekdayHeader(day: 'FRI'),
                _WeekdayHeader(day: 'SAT'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('8', style: TextStyle(color: Colors.black87)),
                Text('9', style: TextStyle(color: Colors.black87)),
                Text('10', style: TextStyle(color: Colors.black87)),
                Text('11', style: TextStyle(color: Colors.black87)),
                Text('12', style: TextStyle(color: Colors.black87)),
                Text('13', style: TextStyle(color: Colors.black87)),
                Text('14', style: TextStyle(color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filterButtons.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: _filterButtons[index],
                      selected: _selectedButtonIndex == index,
                      onSelected: (selected) {
                        setState(() {
                          _selectedButtonIndex = selected ? index : 0;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Column(
      children: [
        _buildEventCard(
          title: "Mandy's 50th Birthday Bash",
          time: "9:30 - 16:00PM",
          tasks: [
            Task(event: "Mandy's", title: "4.39 Hour"),
            Task(event: "Mandy's", title: "Hernandez's"),
          ],
          color: Colors.orange[100],
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          title: "Family Gathering",
          time: "16:00 - 21:00PM",
          tasks: [
            Task(event: "Family", title: "17:1 Hours"),
            Task(event: "Family", title: "Atlanta Conference Room"),
          ],
          color: Colors.blue[100],
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          title: "Community Planning Meeting",
          time: "17:12 Hours",
          tasks: [
            Task(event: "Meeting1", title: "17:12 Hours"),
            Task(event: "Meeting1", title: "Atlanta Conference Room"),
          ],
          color: Colors.green[100],
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          title: "Community Planning Meeting",
          time: "7:30 - 14:00PM",
          tasks: [
            Task(event: "Meeting2", title: "7:30 - 14:00PM"),
            Task(event: "Meeting2", title: "Atlanta Conference Room"),
          ],
          color: Colors.purple[100],
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String time,
    required List<Task> tasks,
    required Color? color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 12),
            Column(children: tasks.map(_buildTaskItem).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    String key = '${task.event}:${task.title}';
    bool isCompleted = _taskCompletionStates[key] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (value) {
              setState(() {
                _taskCompletionStates[key] = value ?? false;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.blue;
              }
              return Colors.grey;
            }),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 8),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String day;

  const _WeekdayHeader({required this.day});

  @override
  Widget build(BuildContext context) {
    return Text(day,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ));
  }
}

class ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
