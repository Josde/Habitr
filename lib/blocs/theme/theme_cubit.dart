import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habitr_tfg/utils/constants.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeLight());
  void switchTheme() => {this.state is ThemeLight? emit(ThemeDark()) : emit(ThemeLight())};
}
