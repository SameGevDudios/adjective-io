import 'package:flutter/material.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/widgets/mood_screen.dart';
import 'package:wife_gift/features/mood_screen/widgets/settings_drawer.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _selectedIndex = 0;

  final List<Widget> _pages = [
    const MoodScreen(),
    const Center(
      child: Text("Вторая страница (Список)", style: TextStyle(color: Colors.white)),
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _scaffoldKey.currentState?.openEndDrawer();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: UiColors.background,
      endDrawer: const SettingsDrawer(),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _BottomNavBar(
        scaffoldKey: _scaffoldKey,
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const _BottomNavBar({
    required this.scaffoldKey,
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: UiColors.accentDark),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home,
            isSelected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),
          _NavBarItem(
            icon: Icons.format_list_bulleted_outlined,
            isSelected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),
          _NavBarItem(
            icon: Icons.settings_outlined,
            isSelected: false,
            onTap: () => scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({required this.icon, required this.isSelected, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: UiColors.white.withAlpha(isSelected ? 255 : 128), size: 32),
      onPressed: onTap,
    );
  }
}
