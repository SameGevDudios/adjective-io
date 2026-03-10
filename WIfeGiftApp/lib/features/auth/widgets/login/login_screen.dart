import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/features/auth/widgets/register/register_screen.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthState$Error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthState$Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Padding(padding: EdgeInsets.all(16), child: LoginForm());
        },
      ),
    );
  }
}
