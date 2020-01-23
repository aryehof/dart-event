# Event

[![Pub Package](https://img.shields.io/pub/v/event.svg?style=flat-square)](https://pub.dev/packages/event)

Supports the creation of lightweight custom Dart Events, that allow interested subscribers to be notified that something has happened. Provides a notification mechanism across independent packages/layers/modules.

This package is inspired by the `C#` language's implementation of `Events` and `Delegates`.

## Background

As developers, we understand that dividing independent functionality into separate modules (packages) is something to which we should aspire.  It can be ideal to model our problem domain independent of user interface, other systems, and technical plumbing. Equally, independent pieces of infrastructure benefit from being in separate modules (packages). Doing so has the same attraction as the decomposition of functionality into separate subroutines, albeit at a larger scale. Let's divide a large problem into smaller pieces, that can be reasoned about and worked on independently, and then re-combined to represent a solution to the problem.

> To make something *independent*, it should should know nothing of the things that might depend on it. -- Aryeh Hoffman

#### An elevator example

Consider for example, that an independent model of the operation of a single elevator needs know nothing of the user interfaces (UI) or system interfaces (SI) dependent on it.  There might be a diagnostics UI written in Flutter, a console (CUI) interface, as well as as a module that only exposes a programmatic interface that external programs might consume to control the elevator. There might be other 'consumers' of the domain model, but that model need not care as it knows nothing of them.

Or does it need to? How do these 'consumers' know when something has happened in the model?  In the case of the elevator, the model might be connected to real physical elevator through a manufacturer supplied control library, which in turn talks to the elevators programmable logic controller (PLC).

How can the physical elevator report that something happened through the control library to the model and in turn to each of the three (or more) consumers? The model knows nothing of its consumers. Likewise, an independent manufacturers control library knows nothing of your elevator domain model.

> How can something that is independent and in a separate module (package), notify a consumer it doesn't know, that something has happened?

##### The solution

The answer provided in this package, is to model an Event that can be published by an independent module (package), and subscribed to by a consumer elsewhere.  An Event represents that something has happened. It can be created and raised (triggered) without the publisher having any connection to those that might be consuming it.

In the case of the elevator, the manufacturers control library can indicate that something in the real elevator happened (via the PLC) by publishing an Event. The domain model can subscribe to those Events where applicable, and cause some change in the model if required - perhaps updating the floor the current elevator is on.

Likewise, the domain model can publish Events which the three consumers of the model can choose to subscribe to.

Note that the three consumers of the model, as well as the model in relation to the elevator control library, remain *independent*.

## Dependencies

None. This Dart package has no non-development dependencies on other packages.

## Implementation Notes

An Event is lightweight. It maintains a list of subscribers, but that list is only instantiated the first time it is subscribed to.  Raising an Event does nothing if no subscribers.

```dart
var onChange = Event();
onChange.raise();

// onChange is lightweight
// raise incurs no cost here as no subscribers
```

An Event can include a custom 'argument' [EventArgs], which supports the subscriber being supplied with some data related to the Event.

```dart
class ChangeArgs extends EventArgs {
  int value;
  ChangeArgs(this.value);
}

var onChange = Event<ChangeArgs>();
onChange.raise(ChangeArgs(61));

// ChangeArgs, and hence its value 61, is passed to all subscribers
```

An Event can also optionally supply the subscriber with the 'sender' of the Event. Typically this is the object that raises the Event.

// TODO: show example of "Sender Event Pattern".

## Examples

Two examples are shown below. The first shows an Event, without an argument provided to handlers (subscribers). The second, shows an Event which does provide a custom argument to the handlers.


#### Example 1: A simple Event with no argument

```dart
import 'package:event/event.dart';

void main() {
  /// An incrementing counter.
  var c = Counter();

  // Subscribe to the custom event
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

// TODO: EventSubscriber requires update

[EventSubscriber][eventsubscriber] - subscribe to Events in `Flutter` that update the enclosed Widget.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[eventsubscriber]: https://pub.dev/packages/eventsubscriber
[tracker]: https://github.com/aryehof/dart-event/issues

