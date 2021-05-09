// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'dart:async';
import 'eventargs.dart';

/// Defines the function (callback) signature of an Event handler.
/// It is a function that takes an argument of type [EventArgs],
/// or one derived from it.
///
/// See also [EventArgs].
typedef EventHandler<T extends EventArgs> = void Function(T? args);

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
class Event<T extends EventArgs> {
  /// The handlers (subscribers) associated with this [Event]. Instantiated
  /// lazily (on demand) to reflect that an [Event] may have no subscribers,
  /// and if so, should not incur the overhead of instantiating an empty [List].
  List<EventHandler<T>>? _handlers;

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
    // instantiate handlers if required
    _handlers ??= [];
    _handlers?.add(handler);
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
    subscribe(handler);
  }

  /// Subscribes a Stream [StreamSink] to an Event.
  ///
  /// This allows a sequence of broadcast Events to
  /// be represented and manipulated as a Stream. The
  /// rich range of mechanisms to filter and manipulate
  /// a Stream become available.
  ///
  /// Remember that the supplied [StreamSink] should
  /// be closed when no longer needed.
  ///
  /// ```dart
  /// // Example
  ///  var e = Event();
  ///  var sc = StreamController();
  ///
  ///  e.subscribeStream(sc.sink);
  ///  e.broadcast();
  ///
  ///  sc.stream.listen((e) => print('boom'));
  ///  sc.close();`
  /// ```
  void subscribeStream(StreamSink sink) {
    _handlers ??= [];
    _handlers?.add((args) => {sink.add(args)});
  }

  /// Removes a handler previously added to this [Event].
  ///
  /// Returns `true` if handler was in list, `false` otherwise.
  /// This method has no effect if the handler is not in the list.
  ///
  /// See also the [-] shorcut version.
  bool unsubscribe(EventHandler<T> handler) {
    if (_handlers == null) return false;
    return _handlers!.remove(handler);
  }

  /// Removes a handler previously added to this [Event].
  ///
  /// Uses "-" as an alternative syntax to the [unsubscribe] method
  /// to remove a handler from this [Event].
  ///
  /// Returns `true` if handler was in list, `false` otherwise.
  /// This method has no effect if the handler is not in the list.
  bool operator -(EventHandler<T> handler) {
    return unsubscribe(handler);
  }

  /// Removes all subscribers (handlers).
  void unsubscribeAll() {
    if (_handlers != null) {
      _handlers?.clear();
      _handlers = null;
    }
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
      return _handlers!.length;
    }
  }

  /// Broadcast this [Event] to subscribers, with an optional [EventArgs] derived argument.
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
  void broadcast([T? args]) {
    // ignore if no handlers
    if (_handlers != null) {
      for (var handler in _handlers!) {
        handler.call(args);
      }
    }
  }

  /// Represent this [Event] as its Type name
  @override
  String toString() {
    return runtimeType.toString();
  }
}
