// lib/features/accounts/presentation/blocs/accounts_bloc/accounts_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:trip_go/features/accounts/domain/repositories/i_auth_repository.dart';
import 'accounts_event.dart';
import 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final IAuthRepository authRepository;

  AccountsBloc({required this.authRepository}) : super(AccountsState.initial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<ChangePasswordEvent>(_onChangePassword);
    on<FetchUserInfoEvent>(_onFetchUserInfo);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    try {
      await authRepository.login(event.username, event.password);
      final user = await authRepository.getUserInfo();
      emit(state.copyWith(status: AccountsStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    try {
      await authRepository.register(event.registrationData);
      emit(state.copyWith(status: AccountsStatus.registered));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    try {
      await authRepository.logout();
      emit(state.copyWith(status: AccountsStatus.unauthenticated, user: null));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    try {
      await authRepository.changePassword(event.oldPassword, event.newPassword);
      emit(state.copyWith(status: AccountsStatus.passwordChanged));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchUserInfo(FetchUserInfoEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    try {
      final user = await authRepository.getUserInfo();
      emit(state.copyWith(status: AccountsStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    try {
      final user = await authRepository.updateProfile(event.updatedData, imageFile: event.imageFile);
      emit(state.copyWith(status: AccountsStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.error, errorMessage: e.toString()));
    }
  }
}
