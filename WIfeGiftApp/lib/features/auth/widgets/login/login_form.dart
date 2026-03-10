import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/utils/app_validators.dart';
import 'package:wife_gift/common/widgets/buttons/link_label.dart';
import 'package:wife_gift/features/auth/data/models/auth_dtos.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/features/auth/widgets/register/register_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent$LoginRequested(
          request: LoginRequest(email: _emailController.text, password: _passwordController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: AppValidators.validatePassword,
          ),
          const SizedBox(height: 4),
          LinkLabel(
            message: 'Нет аккаунта',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(onPressed: _onLoginPressed, child: const Text('Войти')),
          ),
        ],
      ),
    );
  }
}
