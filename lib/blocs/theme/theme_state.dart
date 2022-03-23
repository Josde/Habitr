part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  ThemeState();
  ThemeData? theme;
}

class ThemeDark extends ThemeState {
  ThemeData? theme = darkTheme;
  @override
  List<Object> get props => [theme!];
}

class ThemeLight extends ThemeState {
   ThemeData? theme = lightTheme;
  @override
  List<Object> get props => [theme!];
}