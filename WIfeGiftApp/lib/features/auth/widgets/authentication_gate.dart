import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/common/widgets/modals/custom_show_modal.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/features/auth/widgets/login/login_screen.dart';
import 'package:wife_gift/features/navigation/widgets/main_navigation_screen.dart';

class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthState$Error) {
            CustomShowModal.show(
              context: context,
              label: const Center(
                child: Text(
                  'Ошибка',
                  style: TextStyle(
                    color: UiColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              builder: (context) => Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: UiColors.textPrimary, fontSize: 14),
                ),
              ),
              denyLabel: 'Понятно',
              onDeny: () async {
                    context.read<AuthBloc>().add(AuthEvent$StatusChecked());
                    Navigator.of(context).pop();
              },
            );
          }
        },
        builder: (context, state) {
          if (state is AuthState$Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthState$LoginSuccess) {
            return state.isAuthenticated ? const MainNavigationScreen() : const LoginScreen();
          }

          if(state is AuthState$Error) {
            return SizedBox.shrink();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
