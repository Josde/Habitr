// SOURCE: https://stackoverflow.com/a/62830114/21787881
/// Clase helper para poder tratar tipados genéricos sin tener que usar reflexión en el códigl.
/// {@category Miscelaneo}
library;

class Typer<T> {
  /// Retorna si el objeto es del tipo T
  bool isType(Object o) => o is T;

  /// Retorna el objeto como un tipo T (ya que por limitaciones de Dart, no podemos hacer cast directamente a un tipo que no venga escrito estáticamente el código)
  T asType(Object o) => o as T;

  bool operator >=(Typer other) => other is Typer<T>;
  bool operator <=(Typer other) => other >= this;
}
