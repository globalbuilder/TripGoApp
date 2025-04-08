import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/get_user_info.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/update_profile.dart';
import 'accounts_event.dart';
import 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final Register registerUseCase;
  final GetUserInfo getUserInfoUseCase;
  final UpdateProfile updateProfileUseCase;
  final ChangePassword changePasswordUseCase;

  AccountsBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,
    required this.getUserInfoUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  }) : super(AccountsState.initial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<FetchUserInfoEvent>(_onFetchUserInfo);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    final result = await loginUseCase.execute(event.username, event.password);
    result.fold(
      (failure) => emit(state.copyWith(status: AccountsStatus.error, errorMessage: failure.message)),
      (token) {
        emit(state.copyWith(status: AccountsStatus.authenticated));
        add(FetchUserInfoEvent());
      },
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    final result = await registerUseCase.execute(event.registrationData, imageFile: event.imageFile);
    result.fold(
      (failure) => emit(state.copyWith(status: AccountsStatus.error, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: AccountsStatus.registered)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    final result = await logoutUseCase.execute();
    result.fold(
      (failure) => emit(state.copyWith(status: AccountsStatus.error, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: AccountsStatus.unauthenticated)),
    );
  }

  Future<void> _onFetchUserInfo(FetchUserInfoEvent event, Emitter<AccountsState> emit) async {
    final result = await getUserInfoUseCase.execute();
    result.fold(
      (failure) => emit(state.copyWith(status: AccountsStatus.error, errorMessage: failure.message)),
      (user) => emit(state.copyWith(status: AccountsStatus.authenticated, user: user)),
    );
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    final result = await updateProfileUseCase.execute(event.updatedData, imageFile: event.imageFile);
    result.fold(
      (failure) => emit(state.copyWith(status: AccountsStatus.error, errorMessage: failure.message)),
      (user) => emit(state.copyWith(status: AccountsStatus.authenticated, user: user)),
    );
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<AccountsState> emit) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    final result =
        await changePasswordUseCase.execute(oldPassword: event.oldPassword, newPassword: event.newPassword);
    result.fold(
      (failure) => emit(state.copyWith(status: AccountsStatus.error, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: AccountsStatus.passwordChanged)),
    );
  }
}
