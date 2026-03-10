import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';

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

          if (state is AuthState$Success) {
            return state.isAuthenticated
                ? const SizedBox.shrink() // return HomeScreen();
                : const SizedBox.shrink(); // return AuthenticationScreen();
          }

          // return ErrorModal();
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
