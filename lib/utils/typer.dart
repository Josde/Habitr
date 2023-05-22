// SOURCE: https://stackoverflow.com/a/62830114/21787881
// Helper class used to give Type data about an object without reflection
class Typer<T> {
  bool isType(Object o) => o is T;
  T asType(Object o) => o as T;
  bool operator >=(Typer other) => other is Typer<T>;
  bool operator <=(Typer other) => other >= this;
}
