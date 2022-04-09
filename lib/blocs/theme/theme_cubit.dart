import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:habitr_tfg/utils/constants.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeBase());
  void switchTheme() => {this.state.theme == lightTheme? emit(ThemeDark()) : emit(ThemeLight())};
}
