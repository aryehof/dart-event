// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'eventargs.dart';

/// Defines the function (callback) signature of an Event handler.
/// It is a function that takes an argument of Type [EventArgs],
/// or one derived from it.
///
/// See also [EventArgs].
typedef EventHandler<T extends EventArgs> = void Function(T args);

/// Represents an Event as some number of handlers (subscribers) that can be
/// notified when a condition occurs, by using the [broadcast] method.
///
/// See also [EventArgs].
///
/// =====
///
/// ```dart
/// // An example of an [Event] with no argument.
/// final onValueChanged = Event();
/// counter.onValueChanged + (_) => print('changed'); // add a handler
/// onValueChanged.broadcast(); // broadcast the [Event] to subscribers
///
/// // An example of an [Event] expecting an argument (see [EventArgs]).
/// final onValueChanged = Event<ChangedValue>();
/// counter.onValueChanged + (args) => print(args.changedValue); // add a handler
/// onValueChanged.broadcast(ChangedValue(value)); // broadcast the [Event] to subscribers
/// ```
class Event<T extends EventArgs> {
  /// The handlers (subscribers) associated with this [Event]. Instantiated
  /// lazily (on demand) to reflect that an [Event] may have no subscribers,
  /// and if so, should not incur the overhead of instantiating an empty [List].
  List<EventHandler<T>> _handlers;

  /// Adds a handler (callback) that will be executed when this
  /// [Event] is raised using the [broadcast] method.
  ///
  /// See also the [+] shorcut version.
  ///
  /// ```dart
  /// // Example
  /// counter.onValueChanged.subscribe((args) => print('value changed'));
  /// ```
  void subscribe(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    // instantiate handlers if required
    _handlers ??= [];
    _handlers.add(handler);
  }

  /// Adds a handler (callback) that will be executed when this
  /// [Event] is raised using the [broadcast] method.
  ///
  /// Uses "+" as an alternative syntax to the [subscribe] method
  /// for adding a handler (callback) that will be executed when
  /// this [Event] is fired using the [broadcast] method.
  ///
  /// ```dart
  /// // Example
  /// counter.onValueChanged + (args) => print('value changed');
  /// ```
  void operator +(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    subscribe(handler);
  }

  /// Removes a handler previously added to this [Event].
  ///
  /// Returns `true` if handler was in list, `false` otherwise.
  /// This method has no effect if the handler is not in the list.
  ///
  /// See also the [-] shorcut version.
  bool unsubscribe(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    return _handlers.remove(handler);
  }

  /// Removes a handler previously added to this [Event].
  ///
  /// Uses "-" as an alternative syntax to the [unsubscribe] method
  /// to remove a handler from this [Event].
  ///
  /// Returns `true` if handler was in list, `false` otherwise.
  /// This method has no effect if the handler is not in the list.
  bool operator -(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    return unsubscribe(handler);
  }

  /// Removes all subscribers (handlers).
  void unsubscribeAll() {
    _handlers.clear();
    _handlers = null;
  }

  /// Returns the number of handlers (subscribers).
  /// ```dart
  /// // Example
  /// int numberOfHandlers = myEvent.subscriberCount
  /// ```
  int get subscriberCount {
    if (_handlers == null) {
      return 0;
    } else {
      return _handlers.length;
    }
  }

  /// Broadcast this [Event] to subscribers, with an optional [EventArgs] argument.
  ///
  /// Ignored if no handlers (subscribers).
  /// Calls each handler (callback) that was previously added to this [Event].
  ///
  /// ```dart
  /// // Example
  /// // Without an [EventArg]
  /// onValueChanged.broadcast();
  ///
  /// // With an argument [EventArg]
  /// onValueChanged2.broadcast(ChangedValue(value));
  /// ```
  void broadcast([T args]) {
    // ignore if no handlers
    if (_handlers != null) {
      for (var handler in _handlers) {
        handler(args);
      }
    }
  }

  /// Represent this [Event] as its Type name
  @override
  String toString() {
    return runtimeType.toString();
  }
}
