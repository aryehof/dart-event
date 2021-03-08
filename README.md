# Event

[![Pub Package](https://img.shields.io/pub/v/event.svg?style=flat-square)](https://pub.dev/packages/event)

This package supports the creation of lightweight custom Dart Events, that allow interested subscribers to be notified that something has happened. Provides a notification mechanism across independent packages/layers/modules.

It is inspired by the `C#` language's implementation of `Events` and `Delegates`.

---

Contents
* [Whats New](#whatsnew)
* [Features and bugs](#featuresbugs)
* [See also for Flutter](#seealso)
* [Dependencies](#dependencies)
* [Background](#background)
* [Implementation Notes](#implementation-notes)
  * [Broadcast to a Stream](#broadcasttostream)
* [Examples](#examples)
  * [1 - A simple Event with no argument](#example1)
  * [2 - An Event with a custom event argument [EventArgs]](#example2)

---

## [What's New](#whatsnew)

See the [Changelog][changelog] for details on changes in each version.

## [Features and bugs](#featuresbugs)

Please file feature requests and bugs at the [issue tracker][tracker].

## [See also for Flutter](#seealso)

[EventSubscriber][eventsubscriber] - A Flutter Widget that can subscribe to an [Event] with optional arguments.

This is a Flutter widget that updates (rebuilds) when an [Event] occurs.

## [Dependencies](#dependencies)

None. This Dart package has no non-development dependencies on other packages.

## [Background](#background)

As developers, we understand that dividing independent functionality into separate modules (packages) is something to which we should aspire. It can be ideal to model our problem domain independently of user interface, other systems, and technical plumbing. Equally, independent pieces of infrastructure benefit from being in separate modules (packages). Doing so has the same attraction as the decomposition of functionality into separate subroutines, albeit at a larger scale. Let's divide a large problem into smaller pieces, that can be reasoned about and worked on independently, and then re-combined to represent a solution to the problem.

> To make something _independent_, it should should know nothing of the things that might depend on it.

#### An elevator example

Consider for example, that an independent model of the operation of a single elevator needs know nothing of the user interfaces (UI) or system interfaces (SI) dependent on it. There might be a diagnostics UI written in `Flutter`, a console (CUI) interface, as well as as a module that only exposes a programmatic interface (API) that external programs might consume to control the elevator.

![](https://www.dropbox.com/s/wt1v75g5s5wwli1/event-example-small.jpg?raw=true)

There might be other 'consumers' of the domain model, but the model need not care as it knows nothing of them.

Or does it need to?

How do these 'consumers' know when something has happened in the model? In the case of the elevator, the model might be connected to a real physical elevator through a manufacturer supplied control library, which in turn talks to the elevator's programmable logic controller (PLC).

How can the physical elevator report that something happened through the control library to the model, and in turn to each of the three (or more) consumers? The model knows nothing of its consumers. Likewise, an independent manufacturers control library knows nothing of your elevator domain model.

> How can something that is independent and in a separate module (package), notify a consumer it doesn't know, that something has happened?

##### The solution

The answer provided in this package, is to model an Event that can be published by an independent module (package), and subscribed to by a consumer elsewhere. An Event represents that something has happened. It can be created and broadcast (triggered) without the publisher having any connection to those that might be consuming it.

In the case of the elevator, the manufacturer's control library can indicate that something in the real elevator happened (via the PLC) by publishing an Event. The domain model can subscribe to those Events where applicable, and cause some change in the model if required - perhaps updating the floor the current elevator is on.

Likewise, the domain model can publish Events which the three consumers of the model can choose to subscribe to.

Note that the three consumers of the model, as well as the model in relation to the elevator control library, remain _independent_.

## [Implementation Notes](#implementation-notes)

An Event is lightweight. It maintains a list of subscribers, but that list is only instantiated the first time it is subscribed to. Broadcasting an Event does nothing if there are no subscribers. With no overhead, or impact on performance, feel free to declare and publish large numbers of Events.

```dart
var changeEvent = Event();
changeEvent.broadcast();

// changeEvent is lightweight
// broadcast incurs no cost here as no subscribers
```

An Event can include a custom 'argument' `EventArgs`, which supports the subscriber being supplied with some data related to the Event.

```dart
// A custom 'argument' class
class ChangeArgs extends EventArgs {
  int value;
  ChangeArgs(this.value);
}

var changeEvent = Event<ChangeArgs>();
changeEvent.broadcast(ChangeArgs(61));

// ChangeArgs, and hence its value 61, is passed to all subscribers
```

// TODO: show example of "Named Event Pattern".

### [Broadcast to a Stream](#broadcasttostream)

Dart streams enable a sequence of events to be filtered and transformed. One can subscribe an `Event` to a stream using the `subscribeStream` method.
The rich range of mechanisms to filter and manipulate Streams become available.

Remember that the supplied [StreamSink] should be closed when no longer needed.

```dart
// Example
var e = Event();
var sc = StreamController();

e.subscribeStream(sc.sink);
e.broadcast();

sc.stream.listen((e) => print('boom'));
sc.close();
```

## [Examples](#examples)

Two examples are shown below. The first shows an Event, without an argument provided to handlers (subscribers). The second, shows an Event which does provide a custom argument to the handlers.

#### [Example x: Basic API](#examplea)

```dart
import 'package:event/event.dart';

void main() {
  /// An incrementing counter defined below.
  int counter = 0

  var counterChanged = Event();

  // Subscribe to the custom event
  c.valueChangedEvent + (args) => print('boom');

  c.increment();
  c.reset();

  // outputs...
  // boom
  // boom
}
```

#### [Example 1: A simple Event with no argument](#example1)

```dart
import 'package:event/event.dart';

void main() {
  /// An incrementing counter defined below.
  var c = Counter();

  // Subscribe to the custom event
  c.valueChangedEvent + (args) => print('boom');

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
  final valueChangedEvent = Event();

  /// Increment the [Counter] [value] by 1.
  void increment() {
    value++;
    // Broadcast the change
    valueChangedEvent.broadcast();
  }

  /// Reset the [Counter] [value] to 0.
  void reset() {
    value = 0;
    // Broadcast the change
    valueChangedEvent.broadcast();
  }
}
```

#### [Example 2: An Event with a custom event argument [EventArgs]](#example2)

```dart
import 'package:event/event.dart';

void main() {
   /// An incrementing counter.
  var c = Counter();

  // Subscribe to the custom event
  c.valueChangedEvent + (args) => print('value changed to ${args?.changedValue}');

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

  /// A custom [Event] with argument [ValueEventArgs]
  /// See [ValueEventArgs] class below.
  final valueChangedEvent = Event<ValueEventArgs>();

  /// Increment the [Counter] [value] by 1.
  void increment() {
    value++;
    // Broadcast the change, supplying the value
    valueChangedEvent.broadcast(ValueEventArgs(value));
  }

  /// Reset the [Counter] [value] to 0.
  void reset() {
    value = 0;
    // Broadcast the change, supplying the value
    valueChangedEvent.broadcast(ValueEventArgs(value));
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

[eventsubscriber]: https://pub.dev/packages/eventsubscriber
[tracker]: https://github.com/aryehof/dart-event/issues
[changelog]: https://pub.dev/packages/event/#-changelog-tab-
