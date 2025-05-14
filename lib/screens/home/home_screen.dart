import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedStatusIndex = 0;

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
  bool get showRecentNotes => selectedStatusIndex != 0; // Show notes only if not Draft

  void toggleAllNotes() {
    setState(() {
      bool newValue = !allSelected;
      selectedNotes = List.generate(selectedNotes.length, (_) => newValue);
    });
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
                    const Text(
                      'Hello,\nTho Panha 👋',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
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
                      child: _TaskCard(
                        color: const Color(0xFFFDEBFB),
                        icon: Icons.bar_chart,
                        title: 'Advertising',
                        subtitle: 'Marketing',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TaskCard(
                        color: const Color(0xFFE4F2FD),
                        icon: Icons.business_center,
                        title: 'Presentations',
                        subtitle: 'Sales',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

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
                          color: selectedNotes[index] ? Colors.blue[50] : Colors.grey[100],
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
        color: selected ? Colors.blue[100] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? Colors.blue : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
