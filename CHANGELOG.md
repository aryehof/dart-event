# Changelog - Event

## Version 3.0.0  (2024-08-05)

This version has BREAKING CHANGES
 
1. Minimum Dart sdk dependency is now 3.4.0
2. An EventArgs instance is created and broadcast automatically if none provided, i.e.
``` dart
  var e = Event();
    // is equivalent to...
  var e = Event<EventArgs>(); 
```
3. An Event can have a name specified. Some code might be subscribed to more than one Event, so this lets one know which Event caused the code to run.
``` dart
  var e = Event("CountUpdatedEvent");
  e.subscribe((args) => print(args.eventName));
  // outputs "null" until the event is broadcast.
  e.broadcast();
  // outputs "CountUpdatedEvent"
```
4. EventArgs includes two accessible values:- eventName and whenOccurred. Both have a default value of `null`, and are only populated when the Event is broadcast.
``` dart
  // Example without Event name
  var e = Event();
  e.subscribe((args) {
    print(args.eventName); // outputs null
    print(args.whenOccurred); // outputs time of broadcast
  };
  e.broadcast();
  
  // Example specifying an Event name
  var e = Event("myEvent");
  e.subscribe((args) {
    print(args.eventName); // outputs "myEvent"
    print(args.whenOccurred); // outputs time of broadcast
  };
  e.broadcast();
```
5. The WhenWhy EventArg derived class is DEPRECATED and removed. Use the EventArgs whenOccurred property instead.
6. The + and - equivalents to subscribe() and unsubscribe() have been DEPRECATED and removed for simplicity.
7. A custom ArgsError is thrown if an Event is broadcast() without an appropriate argument
``` dart
  var e = Event<CustomEventArgs>();
  // following throws an ArgsError because broadcast()
  // specifies no CustomEventArgs
  e.broadcast();
  // In this case, the ArgsError message shown would be...
  // "Incorrect args being broadcast - args should be a CustomEventArgs"
  
  // instead, following is correct
  e.broadcast(CustomEventArgs("hello"));
```
8. A new property genericType has been added to the Event class. Gets the generic type of the Event, e.g.
``` dart
  var e = Event<Value<int>>();
  assert(e.genericType == Value<int>); 
```
9. The broadcast() method now returns a bool, indicating if the broadcast had subscribers or not. No subscribers means the broadcast() method is effectively ignored.
``` dart
  var e = Event();
  // no subscribers
  var hadEffect = e.broadcast();
  assert(hadEffect == false);
```
10. A syntactical alternative to the `broadcast` method - `notifySubscribers` - has been added.

## Version 2.1.2  (2022-01-11)

- Small README changes

## Version 2.1.0  (2022-01-10)

- Improved README

- ** Breaking Changes **
  - `StdEventArgs` renamed to `WhenWhy` to better indicate what the arguments represent.

```dart
  var e = Event<WhenWhy>();
  e.broadcast(WhenWhy(description: 'some info'));  
```

  - EventArgs `Value` and `Values` now derive from `EventArgs` rather than WhenWhy (formerly StdEventArgs).

## Version 2.0.5  (2021-05-10)

- Fix issue #5. Support the ability to unsubscribeAll within an Event handler.

## Version 2.0.4  (2021-05-10)

- `GenericEventArg1` and `GenericEventArg2` Event argument types renamed to `Value` and `Values`. Better reflects common usage. `Values` supports two values, while `Value` supports one.

```dart
      var e = Event<Value>(); // Event will include a value as an argument
      e.broadcast(Value(39)); // type of the Value inferred to be an int

      // equivalent to 

      var e = Event<Value<int>>();  // type of the Value can also be explicit
      e.broadcast(Value(39));
```

- Updated tests.

## Version 2.0.3  (2021-05-09)

- Make the list of handlers a non-nullable Type that is created lazily using  the new 'late' keyword.

This simplifies the code substantially, because no null checks etc. are required.

## Version 2.0.2  (2021-05-08)

- Fixed issue #7 https://github.com/aryehof/dart-event/issues/7
- Updated tests.

## Version 2.0.1  (2021-03-08)

- Fixed incorrect link to Changelog in README.

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