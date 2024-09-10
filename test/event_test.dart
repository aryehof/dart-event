import 'dart:async';
import 'dart:io';
import 'package:event/event.dart';
import 'package:event/src/errors.dart';
import 'package:test/test.dart';

/// An example derived EventArgs class for use in tests
class MyCustomEventArgs extends EventArgs {}

void main() {
  group('Event Tests', () {
    setUp(() {
      // enable log output
      showLog(stdout, Severity.allExceptDebug);
    });

    test('Subscriber count is 0 for an Event with no subscribers', () {
      var e = Event();
      // no subscriber
      expect(e.subscriberCount, isZero);
    });

    test('Subscriber count is 1 on adding a single subscriber', () {
      var e = Event();
      e.subscribe((args) => {});
      expect(e.subscriberCount, equals(1));
    });

    test('Subscriber count is 2 on adding two subscribers', () {
      var e = Event();
      e.subscribe((args) => print('foo'));
      e.subscribe((args) => print('bar'));

      expect(e.subscriberCount, equals(2));
    });

    test('Calling unsubscribe removes a handler', () {
      var e = Event();
      myHandler(args) {} // local function declaration
      e.subscribe(myHandler);
      expect(e.subscriberCount, equals(1));

      bool successfulUnsubscribe = e.unsubscribe(myHandler);
      expect(successfulUnsubscribe, isTrue);

      successfulUnsubscribe = e.unsubscribe(myHandler);
      expect(successfulUnsubscribe, isFalse);

      expect(e.subscriberCount, isZero);
    });

    test('Calling unsubscribe with no handlers returns false', () {
      var e = Event();
      myHandler(args) {} // local function declaration

      bool result = e.unsubscribe(myHandler);
      expect(result, equals(false));
    });

    test('Calling unsubscribeAll with no handlers results in no exceptions', () {
      var e = Event();
      expect(() => e.unsubscribeAll(), returnsNormally);
      expect(e.subscriberCount, isZero);
    });

    test('Calling broadcast with no generic type is successful', () {
      bool changedInHandler = false;

      var e = Event();
      e.subscribe((args) => changedInHandler = true);
      e.broadcast();
      expect(changedInHandler, isTrue);
    });

    test('Calling broadcast with explicit EventArgs succeeds', () {
      var e = Event<EventArgs>();
      e.subscribe((args) => {});
      var hasSubscriber = e.broadcast(EventArgs());

      expect(hasSubscriber, isTrue);
    });

    test('Calling broadcast with typed Value successful', () {
      // a value expected to change when event is raised
      int changedInHandler = -1;

      var e = Event<Value<int>>();
      e.subscribe((args) => changedInHandler = args.value);
      e.broadcast(Value(39));

      expect(changedInHandler, equals(39));
    });

    test('Calling broadcast with dynamic Value is successful', () {
      // a value expected to change when event is raised
      int changedInHandler = -1;

      var e = Event<Value>();
      e.subscribe((args) => changedInHandler = args.value);
      e.broadcast(Value(41));

      expect(changedInHandler, equals(41));
    });

    test('Use whenOccured EventArg field correctly', () {
      DateTime? eventOccurred;

      var e = Event(); // <EventArgs> assumed
      e.subscribe((args) {
        eventOccurred = args.whenOccurred;
      });
      e.broadcast();
      expect(DateTime.now().difference(eventOccurred!), lessThan(Duration(milliseconds: 250)));
    });

    test('Can set an Event name which is then available in args', () {
      String? eventName;

      var e = Event('myTestEvent');
      e.subscribe((args) {
        eventName = args.eventName;
      });
      e.broadcast();

      expect(eventName, "myTestEvent");
    });

    test('Setting no Event name results in the arg name value of ""', () {
      String? eventName;

      var e = Event();
      e.subscribe((args) {
        eventName = args.eventName;
      });
      e.broadcast();

      expect(eventName, "");
    });

    test('Single Value as a generic Event argument', () {
      String? value;

      var e = Event<Value<String>>();
      e.subscribe((args) => value = args.value);
      e.broadcast(Value('hello'));

      expect(value, equals('hello'));
    });

    test('Single Value as a generic argument, where value type is dynamic', () {
      String value = '';

      var e = Event<Value>(); // Value is implicitly a string per the constructor
      e.subscribe((args) => value = args.value);
      e.broadcast(Value('any string'));
      expect(value, equals('any string'));
    });

    test('Using Value as a Map', () {
      Map map = {};

      var e = Event<Value>(); // Value is implicitly a Map per the constructor
      e.subscribe((args) => map = args.value);
      e.broadcast(Value({'name': 'alex'}));
      expect(map['name'], equals('alex'));
    });

    test('Two Values as generic Event arguments', () {
      String? value1;
      int? value2;

      var e = Event<Values<String, int>>();
      e.subscribe((args) {
        value1 = args.value1;
        value2 = args.value2;
      });
      e.broadcast(Values('boom', 37));
      expect(value1, equals('boom'));
      expect(value2, equals(37));
    });

    test('Two Values as generic Event arguments, where value types are dynamic', () {
      String? value1;
      int? value2;

      var e = Event<Values>();
      e.subscribe((args) {
        value1 = args.value1;
        value2 = args.value2;
      });
      e.broadcast(Values('boom', 37));
      expect(value1, equals('boom'));
      expect(value2, equals(37));
    });

    test('wrapped Event pattern', () {
      int currentYear = 2022;
      int? changedByEvent;

      // "wrapped Event Pattern"
      // 1. declare the Event.
      //    By convention, use an 'Event' suffix for the name.
      var changeEvent = Event<Value>();

      // 2. Wrap [broadcastWithContext] with an on... function.
      //    By convention use an '_on' prefix for the name.
      //    This is called to broadcast the Event to subscribers.
      void _onChange() {
        // Typically the [context] would be 'this'. A global variable
        // is used in this case because 'this' is not available in a
        // test.
        // changeEvent.broadcastWithContext(year, args);

        changeEvent.broadcast(Value(currentYear));
      }

      // 3. add a handler (where applicable) to the Event
      changeEvent.subscribe((args) => changedByEvent = args.value);

      // 4. call the wrapped on... function to raise the Event
      _onChange();

      expect(changedByEvent, equals(2022));
    });

    test('Event broadcasts to Stream with no args', () async {
      bool? testResult;

      var e = Event();
      var sc = StreamController();

      e.subscribeStream(sc.sink);
      e.broadcast();

      sc.stream.listen((e) {
        testResult = true;
      });
      await sc.close();
      expect(testResult, equals(true));
    });

    test('Event broadcasts to Stream with args', () async {
      bool? hasPassed;

      var e = Event<Value<int>>();
      var sc = StreamController<Value<int>>();

      e.subscribeStream(sc.sink);
      e.broadcast(Value(17));
      e.broadcast(Value(36));

      sc.stream.listen((e) {
        if (e.value == 36) {
          hasPassed = true;
        }
      });

      await sc.close();
      expect(hasPassed, equals(true));
    });

    test('Method toString() returns the Event name and Type when the Event is named', () {
      var e = Event('myTestEvent');
      expect(e.toString(), equals("myTestEvent:Event<EventArgs>"));
    });

    test('Method toString() returns UnNamed and the Type when the Event is not named', () {
      var e = Event();
      expect(e.toString(), equals("Unnamed:Event<EventArgs>"));
    });

    // see Issue #5 - Subscribe once and exception
    test('Can Unsubscribe in handler enabling "subscribeOnce" behavior', () {
      var e = Event();
      e.subscribe((args) => e.unsubscribeAll());
      e.broadcast();
      expect(e.subscriberCount, equals(0));
    });

    test('Can get the event name from args if set', () {
      var expectedName = "myEvent";
      String receivedName = '';

      var e = Event(expectedName);
      e.subscribe((args) => receivedName = args.eventName!);
      e.broadcast();

      expect(receivedName, equals(expectedName));
    });

    test('Expect the event name to be empty if not set', () {
      String? result; // null

      var e = Event();
      e.subscribe((args) => result = args.eventName);
      e.broadcast();

      expect(result, equals(''));
    });

    test('Broadcasting with wrong arg type should throw exception', () {
      var e = Event<Value>();
      e.subscribe((args) => print("Subscribed"));
      expect(() => e.broadcast(), throwsA(TypeMatcher<ArgsError>()));
    });

    test('Event type via genericType is reported correctly', () {
      var e = Event();
      expect(e.genericType, equals(EventArgs));

      e = Event<Value>();
      expect(e.genericType, equals(Value<dynamic>));

      e = Event<Value<int>>();
      expect(e.genericType, equals(Value<int>));

      e = Event<MyCustomEventArgs>();
      expect(e.genericType, equals(MyCustomEventArgs));
    });
  });

  group('EventArgs Tests', () {});
}
