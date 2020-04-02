// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'EventSubscriber.dart';
import 'eventargs.dart';

/// Represents an Event as some number of handlers (subscribers) that can be
/// notified when a condition occurs, by using the [broadcast] method.
///
/// See also [EventArgs].
///
/// =====
///
/// ```dart
/// // An example of a simple [Event] with no argument.
/// final onValueChanged = Event();
/// counter.onValueChanged + (_) => print('changed'); // add a handler
/// onValueChanged.broadcast(); // broadcast the [Event] to subscribers
///
/// // An example of an [Event] expecting an argument (see [EventArgs]).
/// final onValueChanged = Event<ChangedValue>();
/// counter.onValueChanged + (args) => print(args.changedValue); // add a handler
/// onValueChanged.broadcast(ChangedValue(value)); // broadcast the [Event] to subscribers
/// ```
class Event<T extends EventArgs> extends EventSubscriber<T> {
  /// Removes all subscribers (handlers).
  void unsubscribeAll() {
    handlers.clear();
    handlers = null;
  }

  /// Returns the number of handlers (subscribers).
  /// ```dart
  /// // Example
  /// int numberOfHandlers = myEvent.subscriberCount
  /// ```
  int get subscriberCount {
    if (handlers == null) {
      return 0;
    } else {
      return handlers.length;
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
  /// onValueChanged2.broadcast(ChangedValue(3.14159));
  /// ```
  void broadcast([T args]) {
    // ignore if no handlers
    if (handlers != null) {
      for (var handler in handlers) {
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
