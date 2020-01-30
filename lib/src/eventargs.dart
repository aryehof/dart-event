// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'package:event/event.dart';

/// Represents the (optional) arguments provided to handlers
///  when an [Event] occurs. For example:
///
/// ```
/// class ValueEventArgs extends EventArgs {
///   int changedValue;
///   ValueEventArgs(this.changedValue);
/// }
/// ```
abstract class EventArgs {}

/// Represents an empty [EventArg] derived class. For use where no
/// arguments are required, and one wants to make explicit the generic
/// type.
/// ```dart
/// var e = Event<EmptyEventArgs>();
/// // is equivalent to...
/// var e = Event();
/// ```
/// The difference is the first above makes it more explicit to a code
/// reader that there are no EventArgs.
class EmptyEventArgs extends EventArgs {}

/// Represents a premade [EventArg] derived class with one (generic) value.
/// For use as a quick alternative to defining your own custom EventArg
/// class.
/// ```dart
/// // example use
/// var e = Event<EventArgs1<String>>();
/// e.subscribe((args) => print(args.value));
/// e.broadcast(EventArgs1('hello'));
///```
class EventArgs1<T> extends EventArgs {
  /// A generic value.
  T value;

  /// Creates an [EventArg1] with one generic [value]
  EventArgs1(this.value);
}

/// Represents a premade [EventArgs] derived class with two (generic) values.
/// For use as a quick alternative to defining your own custom EventArg
/// class.
/// ```dart
/// // example use
/// var e = Event<EventArgs2<String, int>>();
/// e.subscribe((args) =>
///       print('${args.value1} - ${args.value2}));
/// e.broadcast(EventArgs2('boom', 37));
///```
class EventArgs2<T1, T2> extends EventArgs {
  /// A generic value.
  T1 value1;
  T2 value2;

  /// Creates an [EventArg2] with two generic values: [value1] and [value2]
  EventArgs2(this.value1, this.value2);
}
