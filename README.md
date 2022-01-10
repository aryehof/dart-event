# Event

[![Pub Package](https://img.shields.io/pub/v/event.svg?style=flat-square)](https://pub.dev/packages/event)

This package supports the creation of lightweight custom Dart Events, that allow interested subscribers to be notified that something has happened. Provides a notification mechanism across independent packages/layers/modules.

It is inspired by the `C#` language's implementation of `Events` and `Delegates`.

---

Contents
* Usage
  * Arguments
  * Broadcast to a Stream
* Whats New
* Features and bugs
* See also for Flutter
* Dependencies
* What's it For?
* Examples
  * 1 - A simple Event with no argument
  * 2 - An Event with a custom event argument

---

## Usage

``` dart
// pubspec.yaml
dependencies:
  event: ^2.0.5

// dart code file
import 'package:event/event.dart';
```

Declare an `Event` and _`broadcast`_ it when the Event occurs.

```dart
var myEvent = Event();
myEvent.broadcast();
```

Elsewhere, _`subscribe`_ something interested in the Event, with a _function_ to execute when the Event occurs, i.e. when it is `broadcast`.

``` dart
myEvent.subscribe((args) => print('myEvent occured'));
```

> An Event is lightweight. It maintains a list of subscribers, but that list is only instantiated the first time it is subscribed to. Broadcasting an Event does nothing if there are no subscribers. With no overhead, or impact on performance, feel free to declare and publish large numbers of Events.

One can use the `+` or `-` operators to as alternatives to using the `subscribe` or `unsubscribe` keywords.

### Arguments

An Event when `broadcast` can provide custom data to subscribers.

One does so, by extending the EventArgs class and providing an instance of it to the `broadcast` Event method.

```dart
// A custom 'argument' class
class Wind extends EventArgs {
  String direction;
  int strength
  Wind(this.direction, this.strength);
}

var weatherEvent = Event<Wind>();
weatherEvent.broadcast(Wind('ENE', 27));

// Wind's direction and strength, is passed to all subscribers

weatherEvent.subscribe((args) => print('${args.direction' ${args.strength}));
```

### Helper Argument Classes

Three prebuilt helper `EventArgs` based classes are included to cover the common cases of wanting to provide subscribers with:-

  1. A single value
  2. Any two values
  3. The date/time the event occurred, and an optional reason/description.

Providing these, means that for these common cases you do not need to create your own custom EventArgs derived argument classes. These three  classes are respectively:-

  1. `Value<T>`, providing a `value` property
  2. `Values<T1, T2>`, providing `value1` and `value2` properties
  3. `WhenWhy`, offering `whenOccured` and optional `description` properties

Consider the following examples of them in use:-

#### ==Value==

``` dart
// value (explicit)
var myValueEvent = Event<Value<int>>();
myValueEvent.broadcast(Value(27)));
myValueEvent.subscribe((args) => {print('${args.value')}; // prints 27
```

Note that in the Value type can be of type `dynamic` and does not therefore need to be explicitly stated. This means that the first line of the above could instead be written as:-

``` dart
// value (dynamic)
var myValueEvent = Event<Value>();  // no <int> type specified
```
#### ==Values==

``` dart
// values (explicit)
var weatherEvent = Event<Values<String, int>>();
weatherEvent.broadcast(Values('ENE', 18)));
weatherEvent.subscribe((args) {
  print('${args.value1}:${args.value2}'));
}); // prints ENE:18
```

As with `Value`, one could omit the Values types and have them be of type dynamic. This means that the first line of the above could instead be written as:-

```dart
// values (dynamic)
var weatherEvent = Event<Values>(); // no <String, int>
```

#### ==WhenWhy==

``` dart
var e = Event<WhenWhy>();
e.broadcast(WhenWhy(description: 'testing')); // description optional
e.subscribe((args) {
  print('${args.whenOccured}:${args?.description}'));
});
```

### Broadcast to a Stream

Dart streams enable a sequence of events to be filtered and transformed. One can subscribe an `Event` to a stream using the `subscribeStream` method.
The rich range of mechanisms to filter and manipulate Streams become available.

Remember that the supplied `StreamSink` should be closed when no longer needed.

```dart
// Example
var e = Event();
var sc = StreamController();

e.subscribeStream(sc.sink);
e.broadcast();

sc.stream.listen((e) => print('boom'));
sc.close();
```

## What's New

See the [Changelog][changelog] for details on changes in each version.

## Requesting Features and Reporting Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

## See also for Flutter

[EventSubscriber][eventsubscriber] - A Flutter Widget that can subscribe to an `Event` with optional arguments.

This is a Flutter widget that _rebuilds_ when an `Event` occurs.

## Dependencies

None. This Dart package has no non-development dependencies on other packages.

## What's it For?

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



// TODO: show example of "Named Event Pattern".


## Examples

Two examples are shown below. The first shows a Counter example where incrementing the counter is broadcast without any argument provided to handlers (subscribers). The second, shows the same but with the incremented Counter value being provided as a custom argument to subscribers.

#### Example 1: A simple increment Event with no argument

```dart
import 'package:event/event.dart';

void main() {
  /// An incrementing counter defined below.
  var c = Counter();

  // Subscribe to the custom event
  c.valueChangedEvent.subscribe((args) => print(c.value));

  c.increment();
  c.increment();
  c.reset();

  // outputs...
  // 1
  // 2
  // 0
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

#### Example 2: A simple increment Event with a custom event argument

```dart
import 'package:event/event.dart';

void main() {
   /// An incrementing counter.
  var c = Counter();

  // Subscribe to the custom event
  c.valueChangedEvent + (args) => print('value changed to ${args?.value}');

  c.increment();
  c.reset();

  // outputs...
  // 1
  // 0
}

//-----------------

/// Represents a number counter that can be incremented.
/// Notifies [Event] handlers (subscribers) when incremented.
/// The notification includes the changed [lastValue]
/// See [Incremented].
class Counter {
  /// The current [Counter] value.
  int value = 0;

  /// A custom [Event] with argument [Incremented]
  /// See [Incremented] class below.
  final valueChangedEvent = Event<Incremented>();

  /// Increment the [Counter] [value] by 1.
  void increment() {
    value++;
    // Broadcast including the incremented value
    valueChangedEvent.broadcast(Incremented(value));
  }

  /// Reset the [Counter] [value] to 0.
  void reset() {
    value = 0;
    // Broadcast the reset value
    valueChangedEvent.broadcast(Incremented(value));
  }
}

//-----------------

/// Represents the arguments provided to handlers
/// when an [Event] occurs.
class Incremented extends EventArgs {
  int lastValue;
  Incremented(this.lastValue);
}
```

[eventsubscriber]: https://pub.dev/packages/eventsubscriber
[tracker]: https://github.com/aryehof/dart-event/issues
[changelog]: https://pub.dev/packages/event/changelog
