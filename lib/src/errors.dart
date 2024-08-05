/// An error that indicates that the argument being [broadcast]
/// does not match the [Event] generic type.
class ArgsError extends TypeError {
  ArgsError(this.message);
  final String message;

  @override
  String toString() {
    return message;
  }
}
