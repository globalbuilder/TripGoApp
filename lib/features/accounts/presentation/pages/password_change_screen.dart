// lib/features/accounts/presentation/pages/password_change_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs//accounts_bloc.dart';
import '../blocs//accounts_event.dart';
import '../blocs//accounts_state.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class PasswordChangeScreen extends StatefulWidget {
  static const routeName = '/change-password';

  const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  late AccountsBloc _accountsBloc;

  @override
  void initState() {
    super.initState();
    _accountsBloc = context.read<AccountsBloc>();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      _accountsBloc.add(
        ChangePasswordEvent(
          _oldPasswordController.text.trim(),
          _newPasswordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: BlocListener<AccountsBloc, AccountsState>(
        listener: (context, state) {
          if (state.status == AccountsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Failed to change password")),
            );
          } else if (state.status == AccountsStatus.passwordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password changed successfully!")),
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AccountsBloc, AccountsState>(
          builder: (context, state) {
            if (state.status == AccountsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _oldPasswordController,
                      label: "Old Password",
                      obscureText: true,
                      icon: Icons.lock_outline,
                      validator: (val) => val == null || val.isEmpty ? "Enter old password" : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _newPasswordController,
                      label: "New Password",
                      obscureText: true,
                      icon: Icons.lock,
                      validator: (val) => (val == null || val.length < 6)
                          ? "Min length is 6"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmNewPasswordController,
                      label: "Confirm New Password",
                      obscureText: true,
                      icon: Icons.lock,
                      validator: (val) {
                        if (val != _newPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(label: "Change Password", onPressed: _changePassword),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}