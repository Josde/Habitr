// SOURCE: https://stackoverflow.com/a/62830114/21787881
/// Clase helper para poder tratar tipados genéricos sin tener que usar reflexión en el códigl.
/// {@category Miscelaneo}
library;

class Typer<T> {
  bool isType(Object o) => o is T;
  T asType(Object o) => o as T;
  bool operator >=(Typer other) => other is Typer<T>;
  bool operator <=(Typer other) => other >= this;
}
