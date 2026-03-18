import 'package:flutter/material.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/common/widgets/buttons/link_label.dart';

class CustomShowModal extends StatelessWidget {
  final Widget? title;
  final WidgetBuilder builder;
  final String? denyLabel;
  final String? acceptLabel;
  final VoidCallback? onDeny;
  final VoidCallback? onAccept;
  const CustomShowModal._({
    this.title,
    required this.builder,
    this.denyLabel,
    this.acceptLabel,
    this.onDeny,
    this.onAccept,
    super.key,
  }) : assert(!((denyLabel == null && onDeny != null) || (denyLabel == null && onDeny != null))),
       assert(
         !((acceptLabel == null && onAccept != null) || (acceptLabel == null && onAccept != null)),
       );

  static void show({
    required BuildContext context,
    Widget? label,
    required WidgetBuilder builder,
    String? acceptLabel,
    String? denyLabel,
    VoidCallback? onDeny,
    VoidCallback? onAccept,
  }) => showDialog(
    context: context,
    builder: (context) => CustomShowModal._(
      title: label,
      builder: builder,
      acceptLabel: acceptLabel,
      denyLabel: denyLabel,
      onAccept: onAccept,
      onDeny: onDeny,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DecoratedBox(
        decoration: BoxDecoration(color: UiColors.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ?title,
              const SizedBox(height: 12),
              Builder(builder: builder),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (acceptLabel != null)
                      LinkLabel(
                        message: acceptLabel!,
                        onTap: onAccept!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: UiColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const Spacer(),
                    if (denyLabel != null)
                      LinkLabel(
                        message: denyLabel!,
                        onTap: onDeny!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: UiColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
