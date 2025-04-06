// lib/features/accounts/presentation/pages/registration_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/messages.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../blocs/accounts_bloc.dart';
import '../blocs/accounts_event.dart';
import '../blocs/accounts_state.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegistrationScreen({Key? key}) : super(key: key);
  
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _username = "";
  String _firstName = "";
  String _lastName = "";
  String _password1 = "";
  String _password2 = "";
  XFile? _pickedImage;

  // Use the same image picking logic as in profile_edit_screen.dart
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AccountsBloc>().add(
        RegisterEvent({
          'username': _username,
          'password1': _password1,
          'password2': _password2,
          'first_name': _firstName,
          'last_name': _lastName,
        }, imageFile: _pickedImage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A47A7), Color(0xFF8E63C5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: const AppLogo(size: 80),
                ),
                const SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Image Picker: display chosen image or a placeholder.
                          GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: _pickedImage != null
                                ? Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: FileImage(File(_pickedImage!.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundColor: theme.colorScheme.primary,
                                    child: const Icon(Icons.person,
                                        size: 40, color: Colors.white),
                                  ),
                          ),
                          const SizedBox(height: 12),
                          // Buttons to pick image from Gallery or Camera.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.photo_library),
                                label: const Text("Gallery"),
                                onPressed: () => _pickImage(ImageSource.gallery),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.camera_alt),
                                label: const Text("Camera"),
                                onPressed: () => _pickImage(ImageSource.camera),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Form Fields
                          CustomTextField(
                            label: "Username",
                            icon: Icons.person,
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? "Enter username" : null,
                            onSaved: (v) => _username = v!.trim(),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: "First Name",
                            icon: Icons.person_outline,
                            onSaved: (v) => _firstName = v?.trim() ?? "",
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: "Last Name",
                            icon: Icons.person_outline,
                            onSaved: (v) => _lastName = v?.trim() ?? "",
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: "Password",
                            icon: Icons.lock,
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Enter password";
                              if (v.length < 5) return "Min 5 characters";
                              return null;
                            },
                            onSaved: (v) => _password1 = v!,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: "Confirm Password",
                            icon: Icons.lock,
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Confirm password";
                              if (v != _password1) return "Passwords do not match";
                              return null;
                            },
                            onSaved: (v) => _password2 = v!,
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<AccountsBloc, AccountsState>(
                            listener: (context, state) {
                              if (state.status == AccountsStatus.error &&
                                  state.errorMessage != null) {
                                MessageUtils.showErrorMessage(context, state.errorMessage!);
                              }
                            },
                            builder: (context, state) {
                              final isLoading =
                                  state.status == AccountsStatus.loading;
                              return CustomButton(
                                label: isLoading ? "Registering..." : "Register",
                                onPressed: isLoading ? null : _register,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Link to navigate to Login screen
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
