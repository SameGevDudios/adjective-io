import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/common/utils/app_validators.dart';
import 'package:wife_gift/common/widgets/buttons/custom_outlined_button.dart';
import 'package:wife_gift/common/widgets/buttons/link_label.dart';
import 'package:wife_gift/common/widgets/form_fields/custom_outlined_form_field.dart';
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
          CustomOutlinedFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            label: 'Почта',
            icon: Icons.email_outlined,
            color: UiColors.textPrimary,
            validator: AppValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomOutlinedFormField(
            controller: _passwordController,
            label: 'Пароль',
            icon: Icons.lock_outline,
            color: UiColors.textPrimary,
            obscureText: true,
            validator: AppValidators.validatePassword,
          ),
          const SizedBox(height: 4),
          LinkLabel(
            message: 'Нет аккаунта',
            color: UiColors.textSecondary,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: CustomOutlinedButton(
              label: 'Войти',
              color: UiColors.textPrimary,
              width: 2,
              onTap: _onLoginPressed,
            ),
          ),
        ],
      ),
    );
  }
}
