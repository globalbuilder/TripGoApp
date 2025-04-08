import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AccountsEvent {
  final String username;
  final String password;
  const LoginEvent(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class RegisterEvent extends AccountsEvent {
  final Map<String, dynamic> registrationData;
  final XFile? imageFile;
  const RegisterEvent(this.registrationData, {this.imageFile});

  @override
  List<Object?> get props => [registrationData, imageFile];
}

class LogoutEvent extends AccountsEvent {}

class ChangePasswordEvent extends AccountsEvent {
  final String oldPassword;
  final String newPassword;
  const ChangePasswordEvent({required this.oldPassword, required this.newPassword});

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class FetchUserInfoEvent extends AccountsEvent {}

class UpdateProfileEvent extends AccountsEvent {
  final Map<String, dynamic> updatedData;
  final XFile? imageFile;
  const UpdateProfileEvent(this.updatedData, {this.imageFile});

  @override
  List<Object?> get props => [updatedData, imageFile];
}
