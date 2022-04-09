part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  ThemeState();
  ThemeData? theme;
}
class ThemeBase extends ThemeState {
  ThemeData? theme;
  ThemeBase() {
    theme = darkTheme; // FIXME: Usar Settings para obtener el ultimo valor NO FUNCIONA para nada.
  }
  @override
  List<Object> get props => [theme!];
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