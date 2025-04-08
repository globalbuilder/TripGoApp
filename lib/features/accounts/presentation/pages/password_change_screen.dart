// lib/features/accounts/presentation/pages/password_change_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../.././../../core/widgets/custom_text_field.dart';
import '../blocs/accounts_bloc.dart';
import '../blocs/accounts_event.dart';
import '../blocs/accounts_state.dart';
import '../../../../core/utils/messages.dart';

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
  
  void _changePassword(){
    if(_formKey.currentState!.validate()){
      context.read<AccountsBloc>().add(
        ChangePasswordEvent(oldPassword: _oldPasswordController.text.trim(), newPassword: _newPasswordController.text.trim())
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: BlocListener<AccountsBloc, AccountsState>(
        listener: (context, state) {
          if(state.status == AccountsStatus.error && state.errorMessage != null){
            MessageUtils.showErrorMessage(context, state.errorMessage!);
          }
          if(state.status == AccountsStatus.passwordChanged){
            MessageUtils.showSuccessMessage(context, "Password changed successfully!");
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(controller: _oldPasswordController, label: "Old Password", obscureText: true),
                const SizedBox(height: 16),
                CustomTextField(controller: _newPasswordController, label: "New Password", obscureText: true),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmNewPasswordController,
                  label: "Confirm Password",
                  obscureText: true,
                  validator: (val) => val != _newPasswordController.text ? "Passwords mismatch" : null,
                ),
                const SizedBox(height: 24),
                CustomButton(label: "Change Password", onPressed: _changePassword),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
