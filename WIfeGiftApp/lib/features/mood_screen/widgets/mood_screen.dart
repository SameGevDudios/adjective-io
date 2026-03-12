import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/data/models/adjective.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';
import 'package:wife_gift/features/mood_screen/logic/prefix_bloc/prefix_bloc.dart';
import 'adjective_tile.dart';
import 'prefix_widget.dart';

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

    return RefreshIndicator(
      color: UiColors.accent,
      backgroundColor: Colors.white,
      onRefresh: () => _onRefresh(context),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                BlocBuilder<PrefixBloc, PrefixState>(
                  builder: (context, state) {
                    if (state is PrefixState$Success) {
                      return PrefixWidget(prefix: state.prefix, size: size);
                    }

                    if(state is PrefixState$Error) {
                      return PrefixWidget(prefix: Prefix.empty(), size: size);
                    }

                    return PrefixWidget(prefix: Prefix(title: '', subtitle: ''), size: size);
                  },
                ),
                Positioned(
                  top: size.height * 0.35,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BlocBuilder<PreferenceBloc, PreferenceState>(
                    builder: (context, state) {
                      if (state is PreferenceState$Success) {
                        return _AdjectiveStaticList(adjectives: state.adjectives);
                      }
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdjectiveStaticList extends StatefulWidget {
  final List<Adjective> adjectives;
  const _AdjectiveStaticList({required this.adjectives});

  @override
  State<_AdjectiveStaticList> createState() => _AdjectiveStaticListState();
}

class _AdjectiveStaticListState extends State<_AdjectiveStaticList> {
  late List<Adjective> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.adjectives);
  }

  @override
  void didUpdateWidget(covariant _AdjectiveStaticList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.adjectives != oldWidget.adjectives) {
      setState(() {
        _items = List.from(widget.adjectives);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return AdjectiveTile(
          key: ValueKey(_items[index].id),
          adjective: _items[index],
          onDismissed: (_) {
            setState(() {
              _items.removeAt(index);
            });
          },
        );
      },
    );
  }
}
