import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/common/widgets/form_fields/custom_outlined_form_field.dart';
import 'package:wife_gift/features/mood_screen/data/models/preference.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';
import 'package:wife_gift/features/mood_screen/widgets/adjective_tile.dart';
import 'package:wife_gift/features/thoughts_screen/widgets/additive_adjective_tile.dart';
import 'package:wife_gift/common/widgets/modals/custom_show_modal.dart';

class ThoughtsScreen extends StatefulWidget {
  const ThoughtsScreen({super.key});

  @override
  State<ThoughtsScreen> createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
  final _newThoughtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.background,
      appBar: AppBar(
        title: Text(
          'Мои мысли о себе',
          style: TextStyle(fontSize: 32, color: UiColors.textLight, fontWeight: FontWeight.bold),
        ),
        backgroundColor: UiColors.accentDark,
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<PreferenceBloc>().add(PreferenceEvent$AllPreferencesRequested()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
                  else if (state is PreferenceState$Success) ...[
                    SliverToBoxAdapter(
                      child: AdditiveAdjectiveTile(
                        onTap: () => _showModal(context),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return AdjectiveTile(adjective: state.adjectives[index]);
                      }, childCount: state.adjectives.length),
                    ),
                  ] else
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
      ),
    );
  }

  void _showModal(BuildContext context) {
    CustomShowModal.show(
      context: context,
      label: Center(
        child: Text(
          'Новая мысль',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: UiColors.textDark,
          ),
        ),
      ),
      builder: (context) {
        return CustomOutlinedFormField(
          color: UiColors.textPrimary,
          controller: _newThoughtController,
        );
      },
      acceptLabel: 'Добавить',
      onAccept: () {
        final text = _newThoughtController.text.trim();

        if (text.isNotEmpty) {
          context.read<PreferenceBloc>()
            ..add(
              PreferenceEvent$AddRequested(
                preferences: [Preference(adjective: text, weight: 0)],
              ),
            )
            ..add(PreferenceEvent$AllPreferencesRequested());
          Navigator.of(context).pop();
        }
      },
      denyLabel: 'Отмена',
      onDeny: () => Navigator.of(context).pop(),
    );
  }
}
