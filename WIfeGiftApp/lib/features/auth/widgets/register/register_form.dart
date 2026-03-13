import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/common/widgets/buttons/custom_outlined_button.dart';
import 'package:wife_gift/common/widgets/form_fields/custom_outlined_form_field.dart';
import 'package:wife_gift/features/auth/data/models/requests/register_request.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/common/utils/app_validators.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent$RegisterRequested(
          request: RegisterRequest(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomOutlinedFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            label: 'Email',
            color: UiColors.textPrimary,
            icon: Icons.email_outlined,
            validator: AppValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomOutlinedFormField(
            controller: _passwordController,
            label: 'Пароль',
            color: UiColors.textPrimary,
            icon: Icons.lock_outline,
            obscureText: true,
            validator: AppValidators.validatePassword,
          ),
          const SizedBox(height: 16),
          CustomOutlinedFormField(
            controller: _confirmPasswordController,
            label: 'Подтвердите пароль',
            color: UiColors.textPrimary,
            icon: Icons.lock_clock_outlined,
            validator: (value) =>
                AppValidators.validateConfirmPassword(value, _passwordController.text),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 72,
            child: CustomOutlinedButton(
              label: 'Зарегистрироваться',
              color: UiColors.textPrimary,
              width: 2,
              onTap: _onRegisterPressed,
            ),
          ),
        ],
      ),
    );
  }
}
