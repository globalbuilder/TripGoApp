// lib/features/accounts/presentation/pages/profile_edit_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../blocs/accounts_bloc.dart';
import '../blocs/accounts_event.dart';
import '../blocs/accounts_state.dart';

class ProfileEditScreen extends StatefulWidget {
  static const routeName = '/profile/edit';

  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  late AccountsBloc _accountsBloc;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _accountsBloc = context.read<AccountsBloc>();
    _accountsBloc.add(FetchUserInfoEvent());
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUpdating = true);
      _accountsBloc.add(UpdateProfileEvent({
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'email': _emailController.text.trim(),
      }, imageFile: _pickedImage));
    }
  }

  void _navigateToChangePassword() {
    Navigator.pushNamed(context, '/change-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profile"),
      ),
      body: BlocListener<AccountsBloc, AccountsState>(
        listener: (context, state) {
          if (state.status == AccountsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Error updating profile")),
            );
            setState(() => _isUpdating = false);
          } else if (state.status == AccountsStatus.authenticated && _isUpdating) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AccountsBloc, AccountsState>(
          builder: (context, state) {
            if (state.status == AccountsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.user == null) {
              return const Center(child: Text("No user data."));
            }

            final user = state.user!;
            _firstNameController.text = user.firstName ?? "";
            _lastNameController.text = user.lastName ?? "";
            _phoneController.text = user.phoneNumber ?? "";
            _addressController.text = user.address ?? "";
            _emailController.text = user.email ?? "";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Image Picker
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _pickedImage != null
                          ? FileImage(File(_pickedImage!.path))
                          : user.imageUrl != null && user.imageUrl!.isNotEmpty
                              ? NetworkImage(user.imageUrl!) as ImageProvider
                              : const AssetImage('assets/images/avatar_placeholder.png'),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(controller: _emailController, label: "Email"),
                            const SizedBox(height: 16),
                            CustomTextField(controller: _firstNameController, label: "First Name"),
                            const SizedBox(height: 16),
                            CustomTextField(controller: _lastNameController, label: "Last Name"),
                            const SizedBox(height: 16),
                            CustomTextField(controller: _phoneController, label: "Phone Number", keyboardType: TextInputType.phone),
                            const SizedBox(height: 16),
                            CustomTextField(controller: _addressController, label: "Address"),
                            const SizedBox(height: 24),
                            CustomButton(label: "Save", onPressed: _updateProfile),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(label: "Change Password", onPressed: _navigateToChangePassword),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
