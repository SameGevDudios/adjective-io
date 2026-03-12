import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';
import 'package:wife_gift/features/mood_screen/widgets/adjective_tile.dart';

class ThoughtsScreen extends StatelessWidget {
  const ThoughtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.background,
      appBar: AppBar(
        title: Text(
          'Мои мысли о себе',
          style: TextStyle(
            fontSize: 32,
            color: UiColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: UiColors.accentDark,
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<PreferenceBloc>().add(PreferenceEvent$AllPreferencesRequested()),
        child: BlocBuilder<PreferenceBloc, PreferenceState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (state is PreferenceState$Loading)
                  const SliverFillRemaining(
                    child: Center(
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: RefreshProgressIndicator(
                          color: UiColors.white,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                  )
                else if (state is PreferenceState$Success)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return AdjectiveTile(adjective: state.adjectives[index]);
                        },
                        childCount: state.adjectives.length,
                      ),
                    ),
                  )
                else
                  const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Здесь пока пусто...\nПотяни вниз, чтобы обновить',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: UiColors.textLight),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}