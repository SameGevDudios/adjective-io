import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';
import 'package:wife_gift/features/mood_screen/widgets/mood_screen.dart';
import 'package:wife_gift/features/mood_screen/widgets/settings_drawer.dart';
import 'package:wife_gift/features/thoughts_screen/widgets/thoughts_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _selectedIndex = 0;

  final List<Widget> _pages = [const MoodScreen(), const ThoughtsScreen()];

  bool _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return false;
    }

    if (index == 2) {
      _scaffoldKey.currentState?.openEndDrawer();
      return false;
    }

    setState(() {
      _selectedIndex = index;
    });

    return true;
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
  final bool Function(int) onItemTapped;

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
            onTap: () {
              final canNavigate = onItemTapped(0);

              if (canNavigate) {
                context.read<PreferenceBloc>().add(PreferenceEvent$PreferencesRequested());
              }
            },
          ),
          _NavBarItem(
            icon: Icons.format_list_bulleted_outlined,
            isSelected: selectedIndex == 1,
            onTap: () {
              context.read<PreferenceBloc>().add(PreferenceEvent$AllPreferencesRequested());
              onItemTapped(1);
            },
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
