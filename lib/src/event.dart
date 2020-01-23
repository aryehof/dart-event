// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'eventargs.dart';

/// Defines the function (callback) signature of an event handler.
/// It is a function that takes two arguments, the sender
/// of the Event, and an argument of Type [EventArgs] or one from it.
///
/// See also [EventArgs].
typedef EventHandler<T extends EventArgs> = void Function(Object sender, T args);

/// Represents an Event as some number of handlers (subscribers) that can be
/// notified when a condition occurs, by using the [raise] (or [raiseWithSender])
///  method.
///
/// See also [EventArgs].
///
/// ```dart
/// // declare an event with no arguments
/// final onValueChanged = Event();
///
/// // alternative example of an event expecting an argument (see [EventArgs])
/// final onValueChanged = Event<ChangedValue>();
/// counter.onValueChanged + (sender, args) => print(args.changedValue); // add a handler
/// onValueChanged.raise(ChangedValue(value)); // raise the [Event] to have handlers called
/// ```
class Event<T extends EventArgs> {
  /// The handlers associated with this [Event]. Instantiated lazily  (on
  /// demand) to reflect that an [Event] may have no handlers, and if
  ///  so, should not incur the overhead of instantiating an empty [List].
  List<EventHandler<T>> _handlers;

  /// Adds a handler (callback) that will be executed when this
  /// [Event] is fired using the [raise] method.
  ///
  /// Example:
  /// ```dart
  /// counter.onValueChanged.addHandler((sender, args) => print('value changed'));
  /// ```
  void addHandler(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    // instantiate handlers if required
    _handlers ??= [];
    _handlers.add(handler);
  }

  /// Uses "+" as an alternative syntax to [addHandler] for adding a handler (callback)
  /// that will be executed when this [Event] is fired using the [raise] method.
  /// For example:
  ///
  /// ```
  /// counter.onValueChanged + (sender, args) => print('value changed');
  /// ```
  void operator +(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    addHandler(handler);
  }

  /// Removes a handler previously added to this [Event].
  ///
  /// Returns true if handler was in list, false otherwise.
  /// This method has no effect if the handler is not in the list.
  bool removeHandler(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    return _handlers.remove(handler);
  }

  /// Uses "-" as an alternative syntax to [removeHandler] to remove a
  /// handler from this [Event].
  ///
  /// Returns true if handler was in list, false otherwise.
  /// This method has no effect if the handler is not in the list.

  bool operator -(EventHandler<T> handler) {
    if (handler is! EventHandler<T>) {
      throw ArgumentError('a handler must be specified');
    }
    return removeHandler(handler);
  }

  /// Get the number of handlers (subscribers).  For example:
  /// ```
  /// int numberOfHandlers = myEvent.count
  /// ```
  int get count {
    if (_handlers == null) {
      return 0;
    } else {
      return _handlers.length;
    }
  }

  /// Broadcast this [Event] to subscribers, with optional [EventArgs] arguments.
  ///
  /// Ignored if no handlers (subscribers).
  /// Calls each handler (callback) that was previously added to this [Event].
  /// Note that the handler's [sender] will be null. Use [raiseWithSender] instead
  /// to have a [sender] supplied to a handler.  See also [raiseWithSender].
  ///
  /// Example:
  /// ```dart
  /// // without an [EventArg]
  /// onValueChanged.raise();
  ///
  /// // with an argument [EventArg]
  /// onValueChanged2.raise(ChangedValue(value));
  /// ```
  void raise([T args]) {
    // ignore if no handlers
    if (_handlers != null) {
      for (var handler in _handlers) {
        handler(null, args);
      }
    }
  }

  /// Broadcast this [Event] to subscribers, including the [sender]
  /// and optional argument.
  ///
  /// Ignored if no handlers (subscribers).
  /// Calls each handler (callback) that was previously added to this [Event].
  ///
  /// The [sender] is typically the object that contains this [Event]. One
  /// would include it if one wanted to provide it to a handler (subscriber).
  /// This method is typically implemented using a pattern called the "sender
  /// event pattern". An example is provided below. See also [raise].
  ///
  /// Example "sender event pattern":
  /// ```dart
  /// // 1. declare the Event. By convention use
  /// //    an 'Event' suffix for the name.
  /// var changeEvent = Event();
  ///
  /// // 2. Wrap [raiseWithSender] with a function.
  /// //    By convention use an 'on' prefix for the name.
  /// //    Note that here 'this' is provided as [sender] in
  /// //    [raiseWithSender].
  /// void onChange(EventArgs args) {
  ///   changeEvent.raiseWithSender(this, args);
  /// }
  ///
  /// // 3. add a handler (where applicable) to the Event
  /// changeEvent.addHandler((sender, args) => {// something});
  ///
  /// // 4. call the wrapped on... function to raise the Event
  /// onChange(EmptyEventArgs());
  /// ```
  void raiseWithSender(Object sender, [T args]) {
    // ignore if no handlers
    if (_handlers != null) {
      if (sender == null) {
        throw ArgumentError('the sender specified should not be null');
      }

      for (var handler in _handlers) {
        handler(sender, args);
      }
    }
  }

  /// Represent this [Event] as its name
  @override
  String toString() {
    return runtimeType.toString();
  }
}
