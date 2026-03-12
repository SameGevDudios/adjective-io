import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/data/models/Adjective.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';
import 'package:wife_gift/features/mood_screen/logic/prefix_bloc/prefix_bloc.dart';
import 'package:wife_gift/features/mood_screen/widgets/adjective_tile.dart';
import 'package:wife_gift/features/mood_screen/widgets/prefix_widget.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<PrefixBloc>().add(PrefixEvent$PrefixesRequested());
    context.read<PreferenceBloc>().add(PreferenceEvent$PreferencesRequested());

    await Future.delayed(const Duration(milliseconds: 250));
  }

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

          RefreshIndicator(
            color: UiColors.accent,
            backgroundColor: Colors.white,
            onRefresh: () => _onRefresh(context),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: size.height * 0.35)),

                BlocBuilder<PreferenceBloc, PreferenceState>(
                  builder: (context, state) {
                    if (state is PreferenceState$Success) {
                      return _AdjectiveSliverList(adjectives: state.adjectives);
                    }
                    if (state is PreferenceState$Loading) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator(color: Colors.white)),
                      );
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: UiColors.accentDark),
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

  Widget _navIcon(IconData icon, {bool isSelected = false}) {
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.white : Colors.white.withOpacity(0.5), size: 34),
      onPressed: () {},
    );
  }
}

class _AdjectiveSliverList extends StatefulWidget {
  final List<Adjective> adjectives;
  const _AdjectiveSliverList({required this.adjectives});

  @override
  State<_AdjectiveSliverList> createState() => _AdjectiveSliverListState();
}

class _AdjectiveSliverListState extends State<_AdjectiveSliverList> {
  late List<Adjective> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.adjectives);
  }

  @override
  void didUpdateWidget(covariant _AdjectiveSliverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.adjectives != oldWidget.adjectives) {
      setState(() {
        _items = List.from(widget.adjectives);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = _items[index];
        return AdjectiveTile(
          key: ValueKey(item.id),
          adjective: item,
          onDismissed: (_) {
            setState(() {
              _items.removeAt(index);
            });
          },
        );
      }, childCount: _items.length),
    );
  }
}
