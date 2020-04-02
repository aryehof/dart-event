// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'eventargs.dart';
import 'package:meta/meta.dart';

/// Defines the function (callback) signature of an Event handler.
/// It is a function that takes an argument of type [EventArgs],
/// or one derived from it.
///
/// See also [EventArgs].
typedef EventHandler<T extends EventArgs> = void Function(T args);

/// Represents an Event that can be subscribed to
/// but without the ability to broadcast 
///
/// See also [EventArgs].
///
abstract class EventSubscriber<T extends EventArgs> {
  /// The handlers (subscribers) associated with this [Event]. Instantiated
  /// lazily (on demand) to reflect that an [Event] may have no subscribers,
  /// and if so, should not incur the overhead of instantiating an empty [List].
  @protected
  List<EventHandler<T>> handlers;

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
    handlers ??= [];
    handlers.add(handler);
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
    return handlers.remove(handler);
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

  /// Represent this [Event] as its Type name
  @override
  String toString() {
    return runtimeType.toString();
  }
}
