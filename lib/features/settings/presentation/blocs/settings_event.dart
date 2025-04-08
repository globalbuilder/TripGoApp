// lib/features/settings/presentation/bloc/settings_event.dart

import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {
  final bool isDark;

  const ToggleDarkModeEvent(this.isDark);

  @override
  List<Object> get props => [isDark];
}

class SwitchLanguageEvent extends SettingsEvent {
  final String languageCode; // "en" or "ar"

  const SwitchLanguageEvent(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
