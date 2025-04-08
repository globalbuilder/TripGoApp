// lib/features/settings/presentation/bloc/settings_state.dart

import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loading, loaded, error }

class SettingsState extends Equatable {
  final bool isDarkMode;
  final String languageCode; // "en" or "ar"
  final SettingsStatus status;

  const SettingsState({
    required this.isDarkMode,
    required this.languageCode,
    required this.status,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      isDarkMode: false,
      languageCode: 'en',
      status: SettingsStatus.initial,
    );
  }

  SettingsState copyWith({
    bool? isDarkMode,
    String? languageCode,
    SettingsStatus? status,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [isDarkMode, languageCode, status];
}
