import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';
import 'package:wife_gift/features/mood_screen/logic/prefix_bloc/prefix_bloc.dart';
import 'package:wife_gift/features/mood_screen/widgets/adjective_tile.dart';
import 'package:wife_gift/features/mood_screen/widgets/prefix_widget.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: UiColors.background,
      body: Stack(
        children: [
          BlocBuilder<PrefixBloc, PrefixState>(
            builder: (context, state) {
              final prefix = state is PrefixState$Success ? state.prefix : Prefix.empty();
              return PrefixWidget(prefix: prefix, size: size);
            },
          ),

          Positioned.fill(
            top: size.height * 0.35,
            child: BlocBuilder<PreferenceBloc, PreferenceState>(
              builder: (context, state) {
                if (state is PreferenceState$Success) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100, top: 20),
                    itemCount: state.adjectives.length,
                    itemBuilder: (context, index) {
                      return AdjectiveTile(adjective: state.adjectives[index]);
                    },
                  );
                }

                if (state is PreferenceState$Loading) {
                  return const Center(child: CircularProgressIndicator(color: UiColors.white));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      // TODO: add page logic
      // bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // TODO: add page logic
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: UiColors.accentDark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home, isSelected: true),
          _navIcon(Icons.format_list_bulleted),
          _navIcon(Icons.settings_outlined),
        ],
      ),
    );
  }

  // TODO: add page logic
  Widget _navIcon(IconData icon, {bool isSelected = false}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
        size: 34,
      ),
      onPressed: () {
        // TODO: add page logic
      },
    );
  }
}