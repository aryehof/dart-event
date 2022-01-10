// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'event.dart';

/// An abstract representation of the (optional) arguments provided
/// to handlers when an [Event] occurs.
///
/// This is intended to be extended with your own custom
/// class, if you want to provide subscribers with some
/// data relating to the [Event].  Alternatively, use one
/// of the three supplied [EventArgs] derived classes:
/// [WhenWhy], [Value] or [Values].
///
/// ```dart
/// // example
/// class MyChangedValue extends EventArgs {
///   int changedValue;
///   MyChangedValue(this.changedValue);
/// }
/// ```
abstract class EventArgs {}

/// An [EventArgs] derived class that includes the date/time
/// the [Event] was broadcast, and an optional description.
///
/// Provides a [whenOccurred] and [description] fields.
///
/// ```dart
/// // example declaration ...
/// var myEvent = Event<WhenWhy>();
/// // broadcast with an optional description ...
/// myEvent.broadcast(WhenWhy(description: 'something'))
/// // in subscriber handler ...
/// print(args.whenOccurred);
/// print(args.description);
/// ```
class WhenWhy extends EventArgs {
  /// The date and time the [Event] was broadcast.
  DateTime whenOccurred;

  /// An optional description or other information.
  String description;

  /// Creates a new [WhenWhy], with an optional description.
  WhenWhy({this.description = ''}) : whenOccurred = DateTime.now();
}

/// Represents an [EventArgs] derived class with one (generic) value.
///
/// For use as a quick alternative to defining your own custom EventArgs
/// class. Provides a [value] field that contains the value supplied on
/// creation.
///
/// See also [Values] which supports 2 (generic) values.
///
///
/// ```dart
/// // example declaration with an inferred type
/// var e = Event<Value>();
/// // equivalent example declaration with an declared type
/// var e = Event<Value<String>>();
/// e.subscribe((args) => print(args.value));
/// e.broadcast(Value('hello'));
/// // outputs: hello
///```
class Value<T> extends EventArgs {
  /// A generic value.
  T value;

  /// Creates a [Value] representing one generic [value]
  Value(this.value);
}

/// Represents an [EventArgs] derived class with two (generic) values.
///
/// For use as a quick alternative to defining your own custom EventArgs
/// class. Provides [value1] and [value2] fields containing the values
/// supplied on creation.
///
/// See also [Value] which supports 1 (generic) value.
///
/// ```dart
/// // example
/// var e = Event<Values<String, int>>();
/// e.subscribe((args) => print('${args.value1} : ${args.value2}'));
/// e.broadcast(Values('boom', 37));
/// // outputs: boom : 37
///```
class Values<T1, T2> extends EventArgs {
  /// A generic value.
  T1 value1;
  T2 value2;

  /// Creates an [Values] representing two generic values: [value1] and [value2]
  Values(this.value1, this.value2);
}
