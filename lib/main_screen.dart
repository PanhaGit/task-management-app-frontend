import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 87,
      decoration: BoxDecoration(
        color: AppColors.iceBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),

      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.brightSkyBlue,
        unselectedItemColor: AppColors.charcoalGray,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.home, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.home_filled, size: 26),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.calendar_today, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.calendar_today_outlined, size: 26),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(), // Placeholder for FAB
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.notifications, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.notifications_active, size: 26),
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.person, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.person, size: 26),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30), // Adjusted to reduce overlap
      child: FloatingActionButton(
        onPressed: () => _onTap(context, 2),
        backgroundColor: AppColors.brightSkyBlue,
        elevation: 4,
        child: const Icon(
          Icons.add,
          size: 30,
          color: AppColors.white,
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}