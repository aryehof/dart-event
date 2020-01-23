import 'package:event/event.dart';

void main() {
  var c = Counter();

  // subscribe to the custom event
  c.onValueChanged + (source, args) => print('value changed to ${args.changedValue}');

  c.increment();
  c.reset();
}

//-----------------

/// Represents a number counter that can be incremented.
/// Notifies [Event] handlers (subscribers) when incremented.
/// The notification includes the changed [value] (see [ValueEventArgs]).
class Counter {
  /// The current [Counter] value.
  int value = 0;

  /// A custom [Event] of type [ValueEventArgs]
  final onValueChanged = Event<ValueEventArgs>();

  /// Increment the [Counter] [value] by 1.
  void increment() {
    value++;
    // raise the event
    onValueChanged.raise(ValueEventArgs(value));
  }

  /// Reset the [Counter] [value] to 0.
  void reset() {
    value = 0;
    onValueChanged.raise(ValueEventArgs(value));
  }
}

//-----------------

/// Represents the arguments provided to handlers
/// when an [Event] occurs.
class ValueEventArgs extends EventArgs {
  int changedValue;

  ValueEventArgs(this.changedValue);
}
