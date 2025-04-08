// lib/features/settings/presentation/bloc/settings_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

import '../../../../core/utils/preferences_helper.dart';
import '../../../../core/theme/theme_manager.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final PreferencesHelper preferencesHelper;
  final ThemeManager themeManager;

  SettingsBloc({
    required this.preferencesHelper,
    required this.themeManager,
  }) : super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<SwitchLanguageEvent>(_onSwitchLanguage);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final isDark = await preferencesHelper.isDarkTheme();
      // If you store language in SharedPreferences, e.g. "language_code"
      final savedLang = await preferencesHelper.getLanguageCode() ?? 'en';
      
      // Apply the saved theme
      themeManager.setTheme(isDark);

      emit(
        state.copyWith(
          isDarkMode: isDark,
          languageCode: savedLang,
          status: SettingsStatus.loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Immediately reflect UI
    emit(state.copyWith(isDarkMode: event.isDark, status: SettingsStatus.loading));

    // Persist to SharedPreferences & ThemeManager
    await preferencesHelper.saveThemeMode(event.isDark);
    themeManager.setTheme(event.isDark);

    emit(state.copyWith(status: SettingsStatus.loaded));
  }

  Future<void> _onSwitchLanguage(
    SwitchLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Immediately reflect UI
    emit(state.copyWith(languageCode: event.languageCode, status: SettingsStatus.loading));

    // Save language in SharedPreferences
    await preferencesHelper.saveLanguageCode(event.languageCode);

    // You may also need to update the app's locale manually or using an approach in main.dart.
    // For instance, if you have an App-level widget that listens to changes in PreferencesHelper,
    // or you do something like: 
    //   AppLocalizations.load(Locale(event.languageCode));

    emit(state.copyWith(status: SettingsStatus.loaded));
  }
}
