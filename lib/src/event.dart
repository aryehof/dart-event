// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:event/src/errors.dart';

import 'eventargs.dart';

/// Defines the function (callback) signature of an Event handler.
/// It is a function that takes an argument of type [EventArgs],
/// or one derived from it.
///
/// See also [EventArgs].
typedef EventHandler<T extends EventArgs> = void Function(T args);

/// Represents an Event as some number of handlers (subscribers) that can be
/// notified when a condition occurs, by using the [broadcast] method.
///
/// See also [EventArgs].
///
/// Note: the example folder contains an example of the Counter app
/// using Events
///
/// =====
///
/// ```dart
/// // An example of a simple Event with no argument.
/// var e = Event();
/// e.subscribe((args) => print('changed')); // add a handler
/// e.broadcast(); // broadcast the Event to subscribers
/// // outputs "changed" to console
///
/// // An example of an Event broadcasting a custom argument (see EventArgs).
/// var e = Event<MyChangedValue>();
/// e.subscribe((args) => print(args.changedValue)); // add a handler
/// e.broadcast(MyChangedValue(37)); // broadcast the Event to subscribers
/// // outputs 37 to console
/// ```
class Event<T extends EventArgs> {
  /// An optional name for the [Event]
  final String eventName;

  /// The handlers (subscribers) associated with this [Event]. Instantiated
  /// lazily (on demand) to reflect that an [Event] may have no subscribers,
  /// and if so, should not incur the overhead of instantiating an empty [List].
  late final List<EventHandler<T>> _handlers = [];

  /// Constructor creates a new Event with an optional [eventName] to identify the [Event].
  ///
  /// To specify that the Event broadcasts values via an EventArgs derived class,
  /// set the generic type, e.g.
  /// ``` dart
  /// var e = Event<Value<int>>();
  /// ```
  ///
  /// Not specifying a generic type means that an EventArgs object will be
  /// broadcast, e.g. the following are equivalent...
  /// ``` dart
  /// var e = Event();
  /// // equivalent to
  /// var e = Event<EventArgs>();
  /// ```
  Event([this.eventName = ""]);

  /// Gets this Events generic type. If not explicitly set, will be [EventArgs], e.g.
  /// ``` dart
  /// var e = Event();
  ///  // is equivalent to
  /// var e = Event<EventArgs>();
  /// ```
  Type get genericType => T;

  /// Adds a handler (callback) that will be executed when this
  /// [Event] is raised using the [broadcast] method.
  ///
  /// ```dart
  /// // Example
  /// counter.onValueChanged.subscribe((args) => print('value changed'));
  /// ```
  void subscribe(EventHandler<T> handler) {
    _handlers.add(handler);
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
  ///  sc.close();
  /// ```
  void subscribeStream(StreamSink sink) {
    _handlers.add((args) => sink.add(args));
  }

  /// Removes a handler previously added to this [Event].
  ///
  /// Returns `true` if handler was in list, `false` otherwise.
  /// This method has no effect if the handler is not in the list.
  ///
  /// Important: There is no way to unsubscribe anonymous handlers
  /// (other than with [unsubscribeAll]) as there is no way to
  /// identify the handler your seeking to unsubscribe.
  bool unsubscribe(EventHandler<T> handler) {
    return _handlers.remove(handler);
  }

  /// Removes all subscribers (handlers).
  void unsubscribeAll() {
    _handlers.clear();
  }

  /// Returns the number of handlers (subscribers).
  /// ```dart
  /// // Example
  /// int numberOfHandlers = myEvent.subscriberCount
  /// ```
  int get subscriberCount {
    return _handlers.length;
  }

  /// Broadcast this [Event] to subscribers, with an optional [EventArgs] derived
  /// argument.
  ///
  /// Ignored if no handlers (subscribers).
  /// Calls each handler (callback) that was previously added to this [Event].
  ///
  /// Returns true if there are associated subscribers, or else false if there
  /// are no subscribers and the broadcast has no effect.
  ///
  /// ```dart
  /// // Example
  /// // Without an <EventArgs> argument
  /// var e = Event();
  /// e.broadcast();
  ///
  /// // Note: above is equivalent to...
  /// var e = Event<EventArgs>();
  /// e.broadcast(EventArgs());
  ///
  /// // With an <EventArgs> argument
  /// var e = Event<ChangedValue>();
  /// e.broadcast(ChangedValue(3.14159));
  /// ```
  /// If the broadcast argument does not match the
  /// Event generic type, then an [ArgsError] will be thrown.
  bool broadcast([args]) {
    if (_handlers.isEmpty) return false;

    // if no EventArgs or derived specified, then create one
    args ??= EventArgs();
    args.eventName = this.eventName;
    args.whenOccurred = DateTime.now().toUtc();

    try {
      for (var i = 0; i < _handlers.length; i++) {
        // log(
        //   'Broadcast Event "$this"',
        //   name: "Event",
        //   time: DateTime.timestamp(),
        // );
        _handlers[i].call(args);
      }
    } on TypeError {
      throw ArgsError("Incorrect args being broadcast - args should be a $genericType");
    }

    return true;
  }

  /// Notify subscribers that this [Event] occurred, with an optional [EventArgs] derived
  /// argument. A direct equivalent of the `broadcast` method.
  ///
  /// Ignored if no handlers (subscribers).
  /// Calls each handler (callback) that was previously added to this [Event].
  ///
  /// Returns true if there are associated subscribers, or else false if there
  /// are no subscribers and the broadcast has no effect.
  ///
  /// ```dart
  /// // Example
  /// // Without an <EventArgs> argument
  /// var e = Event();
  /// e.notifySubscribers();
  ///
  /// // Note: above is equivalent to...
  /// var e = Event<EventArgs>();
  /// e.notifySubscribers(EventArgs());
  ///
  /// // With an <EventArgs> argument
  /// var e = Event<ChangedValue>();
  /// e.notifySubscribers(ChangedValue(3.14159));
  /// ```
  /// If the notifySubscribers argument does not match the
  /// Event generic type, then an [ArgsError] will be thrown.
  bool notifySubscribers([args]) {
    return broadcast(args);
  }

  /// Represent this [Event] as its (optional) name + Type
  @override
  String toString() {
    if (eventName.isEmpty) {
      return "Unnamed:${runtimeType.toString()}";
    } else {
      return "$eventName:${runtimeType.toString()}";
    }
  }
}
