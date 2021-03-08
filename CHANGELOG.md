# Changelog - Event

## Version 2.0.1  (2021-03-08)

- Fixed incorrect link to Changelog in README

## Version 2.0.0  (2021-03-08)

- Null safe. (Min SDK version 2.12.0)
- Changes to README content and layout.

## Version 1.1.5  (2021-02-28)

* Minor changes to README content and layout.

## Version 1.1.4  (2020-06-10)

- Added a `subscribeStream` method to Event, which supports the broadcasting of Events to a Dart `Stream` [StreamSink].
  
  This allows a sequence of broadcast Events to be represented and manipulated as a Dart `Stream`. The rich range of mechanisms to filter and manipulate Streams become available.
  
  Remember that the supplied [StreamSink] should be closed when no longer needed.
  
  ```dart
  // Example
   var e = Event();
   var sc = StreamController();
  
   e.subscribeStream(sc.sink);
   e.broadcast();
  
   sc.stream.listen((e) => print('boom'));
   sc.close();
  ```
  
## Version 1.1.3  (2020-02-14)

- BasicEventArgs renamed to StdEventArgs for clarity.

## Version 1.1.2  (2020-02-09)

- EventArgs changes
  - Added `BasicEventArgs` as a standard `EventArgs` derived type.  It includes a `whenOccurred` field that contains the date and time the Event was `broadcast`, as well as an optional `description` field.
  - Renamed `EventArgs1` and `EventArgs2` to `GenericEventArgs1` and `GenericEventArgs2` respectively, to better indicate their purpose. Both are now derived from `BasicEventArgs`, meaning that they have `whenOccurred` and (optional) `description` fields.
  - Improvements to documentation
- Minor improvements to Event documentation.

## Version 1.1.1  (2020-02-03)

- Add new method `unsubscribeAll`, to unsubscribe all subscribers (handlers).

## Version 1.1.0  (2020-01-29)

#### Breaking Change

The function signature for an Event has been simplified. The `sender` argument has been removed, leaving only the need to provide an optional `argument` derived from type `EventArgs`.

The `sender` argument was previously intended to be used to provide the source of the Event, or the object in which the Event was declared, to a subscriber. This can be equally well done within an EventArg passed as an argument to a subscriber.

```dart
// Before
// subscribe to onValueChanged Event
myCounter.onValueChanged + (sender, args) => print('before');

// Now
// subscribe to onValueChanged Event
myCounter.onValueChanged + (args) => print('after');
```

#### Other Breaking Changes

- Renamed `addHandler` and `removeHandler` methods to `subscribe` and `unsubscribe` respectively.
- Renamed `raise` methods to `broadcast`.
- Method `broadcastWithSubject` removed to reflect to removal of `sender` described above.
- The `count` method has been renamed to `subscriberCount'

#### Other

- Two general purpose EventArg derived classes (`EventArgs1` and `EventArgs2`) have been included, which offers a quick alternative to producing your own custom EventArgs class.

EventArgs1 supports one generic value, while EventArgs2 supports two. Example:-

```dart
// EventArgs1 (one value)
var e = Event<EventArgs1<String>>();
e.subscribe((args) => print(args.value));
e.broadcast(EventArgs1('hello'));
// prints hello

// EventArgs2 (two values)
var e = Event<EventArgs2<String, int>>();
e.subscribe((args) => print('${args.value1} - ${args.value2}'));
e.broadcast(EventArgs2('boom', 37));
// prints boom - 37
```

## Version 1.0.3  (2020-01-22)

- Added image of elevator example to README.

## Version 1.0.2  (2020-01-22)

- Updated reference to Flutter [EventSubscriber] in the README.
- Minor documentation improvements

## Version 1.0.1  (2020-01-22)

- Documentation improvements and corrections

## Version 1.0.0  (2020-01-22)

- Initial release 

[eventsubscriber]: https://pub.dev/packages/eventsubscriber