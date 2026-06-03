// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {
  final bool isDarkMode;
  ToggleThemeEvent(this.isDarkMode);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  final Box _settingsBox = Hive.box('settings');

  ThemeBloc() : super(ThemeMode.system) {
    on<ToggleThemeEvent>((event, emit) {
      final mode = event.isDarkMode ? 'dark' : 'light';
      _settingsBox.put('theme_mode', mode);

      emit(event.isDarkMode ? ThemeMode.dark : ThemeMode.light);
    });

    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final String? savedMode = _settingsBox.get('theme_mode');

    if (savedMode == 'dark') {
      emit(ThemeMode.dark);
    } else if (savedMode == 'light') {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.system);
    }
  }
}
