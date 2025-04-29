import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/constants/app_string.dart';
import 'package:frontend_app_task/router/app_router.dart';
class MainScreen extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const MainScreen({
    required this.child,
    required this.selectedIndex,
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.pushToHome();
        break;
      case 1:
        context.pushToCalendar();
        break;
      case 2:
        context.pushToAddTask();
        break;
      case 3:
        context.pushToNotification();
        break;
      case 4:
        context.pushToProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: AppString.bottomNavigationBarItem.map((item) {
          final isActive = _selectedIndex == AppString.bottomNavigationBarItem.indexOf(item);
          return BottomNavigationBarItem(
            icon: Icon(
              isActive ? item["active_icon"] : item["icon"],
              size: 24,
            ),
            label: item["text"],
          );
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.brightSkyBlue,
        unselectedItemColor: AppColors.charcoalGray,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}