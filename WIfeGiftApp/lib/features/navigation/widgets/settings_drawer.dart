import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/common/widgets/form_fields/custom_outlined_form_field.dart';
import 'package:wife_gift/common/widgets/modals/custom_show_modal.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/features/mood_screen/data/models/preference.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';
import 'package:wife_gift/features/mood_screen/logic/prefix_bloc/prefix_bloc.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final _prefixTitleController = TextEditingController();
  final _prefixSubtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: UiColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Настройки',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () {
                  _showModal(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Добавить заголовок',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(AuthEvent$LogoutRequested());
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, size: 28),
                      SizedBox(width: 10),
                      Text('Выйти', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
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
          'Новый заголовок',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: UiColors.textDark),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomOutlinedFormField(
              label: 'Первая строчка',
              color: UiColors.textPrimary,
              controller: _prefixTitleController,
            ),
            const SizedBox(height: 12),
            CustomOutlinedFormField(
              label: 'Вторая строчка',
              color: UiColors.textPrimary,
              controller: _prefixSubtitleController,
            ),
          ],
        );
      },
      acceptLabel: 'Добавить',
      onAccept: () {
        final title = _prefixTitleController.text;
        final subtitle = _prefixSubtitleController.text;

        if (title.isNotEmpty && subtitle.isNotEmpty) {
          context.read<PrefixBloc>().add(
            PrefixEvent$PrefixAddRequested(
              prefixes: [Prefix(title: title, subtitle: subtitle)],
            ),
          );
          Navigator.of(context).pop();
        }
      },
      denyLabel: 'Отмена',
      onDeny: () => Navigator.of(context).pop(),
    );
  }
}
