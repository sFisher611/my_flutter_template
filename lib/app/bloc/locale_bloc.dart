import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart'; 


abstract class LocaleEvent {}
class ChangeLocaleEvent extends LocaleEvent {
  final String languageCode;
  ChangeLocaleEvent(this.languageCode);
}

class LocaleBloc extends Bloc<LocaleEvent, Locale> {
  final Box _settingsBox = Hive.box('settings');
  LocaleBloc() : super(const Locale('uz')) {
    on<ChangeLocaleEvent>((event, emit) {  
      _settingsBox.put('language_code', event.languageCode);
      emit(Locale(event.languageCode));
    });
    _loadSavedLocale();
  }
  void _loadSavedLocale() {
    
    final String code = _settingsBox.get('language_code', defaultValue: 'uz');
    add(ChangeLocaleEvent(code));
  }
}