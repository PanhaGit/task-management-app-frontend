import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;
  double _fabScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomAppBar(
          height: 85,
          color: Colors.white,
          padding: EdgeInsets.zero,
          notchMargin: 10,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, "assets/icon/home (1).png",
                  "assets/icon/home.png", 'Home'),
              _buildNavItem(context, 1, "assets/icon/calendar.png",
                  "assets/icon/calendar (1).png", 'Calendar'),
              const SizedBox(width: 56), // Space for FAB
              _buildNavItem(context, 3, "assets/icon/notification.png",
                  "assets/icon/notification (1).png", 'Notifications'),
              _buildNavItem(context, 4, "assets/icon/user.png",
                  "assets/icon/user (1).png", 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String iconPath,
      String activeIconPath, String label) {
    final isSelected = widget.navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        _onTap(context, index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isSelected ? 8 : 0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brightSkyBlue.withOpacity(0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(
                  isSelected ? activeIconPath : iconPath,
                  color: isSelected ? AppColors.brightSkyBlue : AppColors.charcoalGray,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 13 : 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.brightSkyBlue : AppColors.charcoalGray,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _fabScale = 0.95),
      onTapUp: (_) => setState(() => _fabScale = 1.0),
      onTapCancel: () => setState(() => _fabScale = 1.0),
      child: AnimatedScale(
        scale: _fabScale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.brightSkyBlue,
                Color.lerp(AppColors.brightSkyBlue, Colors.lightBlue, 0.3)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brightSkyBlue.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                _onTap(context, 2);
                setState(() => _fabScale = 1.0);
              },
              child: Center(
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: Image.asset("assets/icon/add.png", color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}