import 'package:event/event.dart';

/*
Summary

1. An Event 'valueChangedEvent' is declared in the Counter class
2. It provides a custom argument to subscribers of the event
      as specified in the ValueEventArgs class at the
       bottom of this page.
   Note that providing an argument to an Event is optional.
3. A subscriber to the Event is added in the main() method.
4. The Event (with custom argument) is broadcast (notified) to
      subscribers in the Counter's increment and reset methods.
*/

void main() {
  var c = Counter();

  // Subscribe to the custom Event.
  c.valueChangedEvent.subscribe((args) => print('value changed to ${args.changedValue}'));

  // The '+' operator is a shortcut for the subscribe method.
  // It is directly equivalent to ...
  // c.onValueChanged + (args) => print('value changed to ${args.changedValue}');

  // Increment the Counter. Subscribers are notified.
  c.increment();

  // Reset the Counter to 0. Subscribers are notified.
  c.reset();
}

//-----------------

/// Represents an example number counter that can be incremented.
///
/// Notifies [Event] handlers (subscribers) when incremented.
/// The notification includes some custom arguments - in this case
/// the changed [value] (see [ValueEventArgs] below).
class Counter {
  /// The current [Counter] value.
  int value = 0;

  /// A custom [Event] of type [ValueEventArgs]
  final valueChangedEvent = Event<ValueEventArgs>();

  /// Increment the [Counter] [value] by 1.
  void increment() {
    value++;
    // notify subscribers of the change in value
    valueChangedEvent.broadcast(ValueEventArgs(value));
  }

  /// Reset the [Counter] [value] to 0.
  void reset() {
    value = 0;
    // notify subscribers of the change in value
    valueChangedEvent.broadcast(ValueEventArgs(value));
  }
}

//-----------------

/// Represents some custom arguments provided to subscribers
/// when an [Event] occurs.
class ValueEventArgs extends EventArgs {
  int changedValue;

  ValueEventArgs(this.changedValue);
}
