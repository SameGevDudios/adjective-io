import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/features/auth/widgets/login/login_screen.dart';
import 'package:wife_gift/features/mood_screen/widgets/mood_screen.dart';

class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthState$Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthState$LoginSuccess) {
            return state.isAuthenticated
                ? MoodScreen()
                : const LoginScreen();
          }

          if (state is AuthState$Error) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
