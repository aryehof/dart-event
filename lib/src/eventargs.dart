// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'package:event/event.dart';

/// An abstract representation of the (optional) arguments provided
/// to handlers when an [Event] occurs.
///
/// This is intended to be extended with your own custom
/// class, if you want to provide subscribers with some
/// data relating to the [Event].  Alternatively, use one
/// of the supplied [EventArgs] derived classes: [BasicEventArgs],
/// [GenericEventArgs1] or [GenericEventArgs2].
///
/// ```dart
/// // example
/// class ValueEventArgs extends EventArgs {
///   int changedValue;
///   ValueEventArgs(this.changedValue);
/// }
/// ```
abstract class EventArgs {}

/// An [EventArgs] extended class that includes the date and
/// time the [Event] was broadcast and an
/// optional description.
///
/// Provides a [whenOccurred] and [description] fields.
///
/// ```dart
/// // example declaration ...
/// var myEvent = Event<BasicEventArgs>();
/// // broadcast with an optional description ...
/// myEvent.broadcast(BasicEventArgs(description: 'something'))
/// // in subscriber handler ...
/// print(args.whenOccurred);
/// print(args.description);
/// ```
class BasicEventArgs extends EventArgs {
  /// The date and time the [Event] was broadcast.
  DateTime whenOccurred;

  /// An optional description.
  String description;

  /// Creates a new [BasicEventArgs], with an optional description.
  BasicEventArgs({this.description}) {
    whenOccurred = DateTime.now();
  }
}

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

/// Represents a [BasicEventArgs] derived class with one (generic) value.
///
/// For use as a quick alternative to defining your own custom EventArgs
/// class. Provides a [value] field that contains the value supplied on
/// creation.
///
/// See also [GenericEventArgs2] which supports 2 (generic) values.
///
/// ```dart
/// // example declaration with an inferred type
/// var e = Event<GenericEventArgs1>();
/// // example declaration with an declared type
/// var e = Event<GenericEventArgs1<String>>();
/// e.subscribe((args) => print(args.value));
/// e.broadcast(GenericEventArgs1('hello'));
/// // outputs: hello
///```
class GenericEventArgs1<T> extends BasicEventArgs {
  /// A generic value.
  T value;

  /// Creates an [EventArg1] with one generic [value]
  GenericEventArgs1(this.value, {String description}) : super(description: description);
}

/// Represents a [BasicEventArgs] derived class with two (generic) values.
///
/// For use as a quick alternative to defining your own custom EventArgs
/// class. Provides [value1] and [value2] fields containing the values
/// supplied on creation.
///
/// See also [GenericEventArgs1] which supports 1 (generic) value.
///
/// ```dart
/// // example
/// var e = Event<EventArgs2<String, int>>();
/// e.subscribe((args) => print('${args.value1} : ${args.value2}'));
/// e.broadcast(EventArgs2('boom', 37));
/// // outputs: boom : 37
///```
class GenericEventArgs2<T1, T2> extends BasicEventArgs {
  /// A generic value.
  T1 value1;
  T2 value2;

  /// Creates an [EventArg2] with two generic values: [value1] and [value2]
  GenericEventArgs2(this.value1, this.value2, {String description})
      : super(description: description);
}
