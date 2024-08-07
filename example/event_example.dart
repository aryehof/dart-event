import 'package:event/event.dart';

/*
Let's define a domain model independent of any user interface.
There is only a single dependency - the Event package - which
lets one...

(#1) declare an Event (something happened),
(#2) subscribe some code to the Event,
(#3) and broadcast to subscribers that the event occurred,
    and the subscribed code should run.

One could have multiple clients use the domain model, be
notified when things change, and then query the domain model
for what has changed.

Note: not shown here is that Events can pass data to
clients, although the more typical architectural model is that
the client will query the model to determine the model state.

 */

/// Represents an example number counter that can be incremented.
class Counter {
  /// The current [Counter] value.
  int count = 0;
  final countChangedEvent = Event(); // (#1)

  /// Increment the [Counter] [count] by 1.
  void increment() {
    count++;
    countChangedEvent.broadcast(); // (#3)
  }

  /// Reset the [Counter] [count] to 0.
  void reset() {
    count = 0;
    countChangedEvent.broadcast(); // (#3)
  }
}

//-----------------
// Use the Counter class and be notified when it changes.

void main() {
  var c = Counter();

  // Subscribe code to run when the Event occurs. (#2)
  c.countChangedEvent.subscribe((args) {
    print('count changed to ${c.count} at ${args.whenOccurred}');
  });

  // Increment the Counter twice. Subscribers are notified,
  // resulting in the print statement above being executed
  // twice.
  c.increment();
  c.increment();

  // Reset the Counter to 0. Subscribers are notified,
  // resulting in the print statement above being executed.
  c.reset();
}
