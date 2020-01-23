# Event

[![Pub Package](https://img.shields.io/pub/v/event.svg?style=flat-square)](https://pub.dev/packages/event)

Provides for the creation of custom Events, that allow interested subscribers to be notified that something has happened. Provides a notification mechanism across independent packages/layers/modules.

This package is inspired by the `C#` language's implementation of `Events` and `Delegates`.

## Background

As developers, we understand that dividing independent functionality into separate modules (packages) is something to which we should aspire.  It can be ideal to model our problem domain independent of user interface, other systems, and technical plumbing. Equally, independent pieces of infrastructure benefit from being in separate modules (packages). Doing so has the same attraction as the decomposition of functionality into separate subroutines, albeit at a larger scale. Let's divide a large problem into smaller pieces, that can be reasoned about and worked on independently, and then re-combined to represent a solution to the problem.

// TODO

## Dependencies

None. This Dart package has no non-development dependencies on other packages.

## Examples

Two examples are provided. The first shows an Event, without an argument provided to handlers (subscribers). The second, shows an Event which does provide a custom argument to the handlers.


#### Example 1: A simple Event with no argument

```dart
import 'package:event/event.dart';

void main() {
  /// An incrementing counter.
  var c = Counter();

  // subscribe to the custom event
  c.onValueChanged + (source, args) => print('boom');

  c.increment();
  c.reset();

  // outputs...
  // boom
  // boom
}

//-----------------

/// Represents a number counter that can be incremented.
/// Notifies [Event] handlers (subscribers) when incremented.
class Counter {
  /// The current [Counter] value.
  int value = 0;

  /// A custom [Event]
  final onValueChanged = Event();

  /// Increment the [Counter] [value] by 1.
  void increment() {
    value++;
    // raise the event
    onValueChanged.raise();
  }

  /// Reset the [Counter] [value] to 0.
  void reset() {
    value = 0;
    onValueChanged.raise();
  }
}
```

#### Example 2: An Event with a custom event argument [EventArgs]

```dart
import 'package:event/event.dart';

void main() {
   /// An incrementing counter.
  var c = Counter();

  // subscribe to the custom event
  c.onValueChanged + (source, args) => print('value changed to ${args.changedValue}');

  c.increment();
  c.reset();

  // outputs...
  // 1
  // 0
}

//-----------------

/// Represents a number counter that can be incremented.
/// Notifies [Event] handlers (subscribers) when incremented.
/// The notification includes the changed [value]
/// See [ValueEventArgs].
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
```

## See also

[EventSubscriber][eventsubscriber] - subscribe to Events in `Flutter` that update the enclosed Widget.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[eventsubscriber]: https://pub.dev/packages/eventsubscriber
[tracker]: https://github.com/aryehof/event/issues

