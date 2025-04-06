// lib/features/accounts/presentation/blocs/accounts_bloc/accounts_state.dart

import 'package:equatable/equatable.dart';
import 'package:trip_go/features/accounts/domain/entities/user_entity.dart';

enum AccountsStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  passwordChanged,
  error,
}

class AccountsState extends Equatable {
  final AccountsStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AccountsState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  factory AccountsState.initial() {
    return const AccountsState(status: AccountsStatus.initial);
  }

  AccountsState copyWith({
    AccountsStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AccountsState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
