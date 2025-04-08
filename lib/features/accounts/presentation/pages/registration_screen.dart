import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_router.dart';
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

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _username = "";
  String _firstName = "";
  String _lastName = "";
  XFile? _pickedImage;

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
        RegisterEvent(
          {
            'username': _username,
            'password1': _passwordController.text,
            'password2': _confirmPasswordController.text,
            'first_name': _firstName,
            'last_name': _lastName,
          },
          imageFile: _pickedImage,
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, AppRouter.login);
    return false;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                            // Display picked image or default avatar
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
                                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                                    ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.photo_library),
                                  onPressed: () => _pickImage(ImageSource.gallery),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () => _pickImage(ImageSource.camera),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: "Username",
                              icon: Icons.person,
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty) ? "Enter username" : null,
                              onSaved: (value) => _username = value!.trim(),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: "First Name",
                              icon: Icons.person_outline,
                              onSaved: (value) => _firstName = value?.trim() ?? "",
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: "Last Name",
                              icon: Icons.person_outline,
                              onSaved: (value) => _lastName = value?.trim() ?? "",
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: "Password",
                              icon: Icons.lock,
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter password";
                                }
                                if (value.length < 5) {
                                  return "Min 5 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: "Confirm Password",
                              icon: Icons.lock,
                              obscureText: true,
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirm password";
                                }
                                if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // BLoC Consumer for register action
                            BlocConsumer<AccountsBloc, AccountsState>(
                              listener: (context, state) {
                                // Show error message if registration fails
                                if (state.status == AccountsStatus.error && state.errorMessage != null) {
                                  MessageUtils.showErrorMessage(context, state.errorMessage!);
                                }
                                // Show success message & go to Login if registration succeeds
                                if (state.status == AccountsStatus.registered) {
                                  MessageUtils.showSuccessMessage(context, "Registration Successful");
                                  Navigator.pushReplacementNamed(context, AppRouter.login);
                                }
                              },
                              builder: (context, state) {
                                final isLoading = state.status == AccountsStatus.loading;
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
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
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
      ),
    );
  }
}
