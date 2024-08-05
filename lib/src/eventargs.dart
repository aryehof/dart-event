// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'event.dart';

/// Represents data (arguments) that is provided to subscribers when
/// an [Event] occurs. It includes two values:- [whenOccurred] - the
/// date/time the [Event] is broadcast, and [eventName] - an optional
/// name that can be used to identify the associated event.
///
/// Extend this class with your own custom
/// derived class, to provide subscribers with
/// some specific data relating to an [Event].
///
/// ```dart
/// // example custom arguments
/// class MyValue extends EventArgs {
///   int myValue;
///   MyValue(this.myValue);
/// }
/// ...
/// var e = Event<MyValue>();
/// e.subscribe((args) => print(args.myValue);
/// e.broadcast(MyValue(99));
/// // prints 99
/// }
/// ```
///
/// Note: An [EventArgs] instance is [broadcast] even when not explicitly
/// specified as an argument to the [broadcast] method. This means that
/// [eventName] and [whenOccurred] are always available.
///
/// ```dart
/// // example ...
/// var e = Event();   // (#1)
/// e.subscribe((args) => print(args.whenOccurred);
/// e.broadcast();  // (#2)
///
/// // prints the date/time the Event e is broadcast.
/// // (#1) equivalent to Event<EventArgs>()
/// // (#2) same as e.broadcast(EventArgs());
/// ```
/// As a shortcut to creating your own custom EventArgs derived class, you can
/// use one of the two provided derived classes:- [Value]
/// and [Values]. These classes let you provide one or two typed values
/// to your subscribers. See the descriptions of these two
/// classes.

class EventArgs {
  /// The name of associated [Event]. Typically set by external code.
  String eventName = '';

  /// The date/time when the event is [broadcast].
  final DateTime whenOccurred;

  /// Constructor creates a new [EventArgs].
  EventArgs() : whenOccurred = DateTime.now();
}

// ------------------------------------------------------------------------------------------------

/// An [EventArgs] derived class with one (generic) value.
///
/// For use as a quick alternative to defining your own custom EventArgs
/// derived class. Provides a [value] field that contains the value
/// supplied on creation.
///
/// See also [Values] which supports 2 (generic) values.
///
///
/// ```dart
/// // example
/// var e = Event<Value>(); // (#1)
/// e.subscribe((args) => print(args.value));
/// e.broadcast(Value('hello'));
///
/// // outputs: hello
/// (#1) equivalent to var e = Event<Value<String>>();
///```
class Value<T> extends EventArgs {
  /// A generic value.
  T value;

  /// Creates a [Value] representing one generic [value]
  Value(this.value);
}

/// An [EventArgs] derived class with two (generic) values.
///
/// For use as a quick alternative to defining your own custom EventArgs
/// class. Provides [value1] and [value2] fields containing the values
/// supplied on creation.
///
/// See also [Value] which supports 1 (generic) value.
///
/// ```dart
/// // example
/// var e = Event<Values>();  // (#1)
/// e.subscribe((args) => print('${args.value1} - ${args.value2}'));
/// e.broadcast(Values('boom', 37));
///
/// // outputs: boom - 37
/// (#1) equivalent to var e = Event<Values<String, int>>();
///```
class Values<T1, T2> extends EventArgs {
  /// A generic value.
  T1 value1;
  T2 value2;

  /// Creates an [Values] representing two generic values: [value1] and [value2]
  Values(this.value1, this.value2);
}
