import 'dart:async';
import 'package:event/event.dart';
import 'package:test/test.dart';

void main() {
  group('Event Tests', () {
    // setUp(() {});

    test('Subscriber count is 0 for Event with no handlers', () {
      var e = Event();
      expect(e.subscriberCount, equals(0));
    });

    test('Adding a handler using "subscribe"', () {
      var e = Event();
      e.subscribe((args) => {});
      expect(e.subscriberCount, equals(1));
    });

    test('Adding a handler using "+" overload', () {
      var e = Event();
      e + (args) => {};
      expect(e.subscriberCount, equals(1));
    });

    test('Adding 2 handlers using subscribe', () {
      var e = Event();
      e + (args) => print('foo');
      e + (args) => print('bar');
      expect(e.subscriberCount, equals(2));
    });

    test('Calling unsubscribe removes a handler', () {
      var e = Event();
      var myHandler = (args) => {};

      e.subscribe(myHandler);
      expect(e.subscriberCount, equals(1));

      bool successfulUnsubscribe = e.unsubscribe(myHandler);
      expect(successfulUnsubscribe, equals(true));

      successfulUnsubscribe = e.unsubscribe(myHandler);
      expect(successfulUnsubscribe, equals(false));

      expect(e.subscriberCount, equals(0));
    });

    test('Using "-" overload for unsubscribe removes a handler', () {
      var e = Event();
      var myHandler = (args) => {};

      e.subscribe(myHandler);
      expect(e.subscriberCount, equals(1));

      bool successfulUnsubscribe = e - myHandler;
      expect(successfulUnsubscribe, equals(true));

      successfulUnsubscribe = e - myHandler;
      expect(successfulUnsubscribe, equals(false));

      expect(e.subscriberCount, equals(0));
    });

    test('Calling unsubscribe with no handlers returns false', () {
      var e = Event();
      var myHandler = (args) => {};

      bool result = e.unsubscribe(myHandler);
      expect(result, equals(false));
    });

    test('Calling unsubscribeAll with no handlers results in no exceptions', () {
      var e = Event();
      expect(() => e.unsubscribeAll(), returnsNormally);
      expect(e.subscriberCount, equals(0));
    });

    test('Calling broadcast successful with no args handler', () {
      bool changedInHandler = false;

      var e = Event();
      e.subscribe((args) => {changedInHandler = true});
      e.broadcast();
      expect(changedInHandler, equals(true));
    });

    test('Calling broadcast with argument successful', () {
      // a value expected to change when event is raised
      int? changedInHandler = -1;

      var e = Event<Value<int>>();
      e.subscribe((args) => {changedInHandler = args?.value});
      e.broadcast(Value(39));

      expect(changedInHandler, equals(39));
    });

    test('Use StdEventArgs fields (whenOccurred and description) correctly', () {
      DateTime? eventOccurred;
      String? description;

      var e = Event<StdEventArgs>();
      e.subscribe((args) {
        eventOccurred = args?.whenOccurred;
        description = args?.description;
      });
      e.broadcast(StdEventArgs(description: 'test description'));
      expect(DateTime.now().difference(eventOccurred!), lessThan(Duration(milliseconds: 250)));
      expect(description, equals('test description'));
    });

    test('Single Value as a generic Event argument', () {
      String? value;

      var e = Event<Value<String>>();
      e.subscribe((args) => value = args?.value);
      e.broadcast(Value('hello'));
      expect(value, equals('hello'));
    });

    test('Single Value as a generic argument, where value type is implicitly derived', () {
      String? value;

      var e = Event<Value>(); // Value is implicitly a string per the constructor
      e.subscribe((args) => value = args?.value);
      e.broadcast(Value('any string'));
      expect(value, equals('any string'));
    });

    test('Two Values as generic Event arguments', () {
      String? value1;
      int? value2;

      var e = Event<Values<String, int>>();
      e.subscribe((args) {
        value1 = args?.value1;
        value2 = args?.value2;
      });
      e.broadcast(Values('boom', 37));
      expect(value1, equals('boom'));
      expect(value2, equals(37));
    });

    test('wrapped Event pattern', () {
      var currentYear = 2020;
      var changedTo;

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
      changeEvent.subscribe((args) => changedTo = args?.value);

      // 4. call the wrapped on... function to raise the Event
      _onChange();

      expect(changedTo, equals(2020));
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
      int? testResult;

      var e = Event<Value<int>>();
      var sc = StreamController<Value<int>>();

      e.subscribeStream(sc.sink);
      e.broadcast(Value(17, description: 'first'));
      e.broadcast(Value(36, description: 'second'));

      sc.stream.listen((e) {
        if (e.value == 36) {
          testResult = 36;
        }
      });

      await sc.close();
      expect(testResult, equals(36));
    });

    test('Event broadcasts to filtered Stream with args', () async {
      int? testResult;

      var e = Event<Value<int>>();
      var sc = StreamController<Value<int>>();

      e.subscribeStream(sc.sink);
      e.broadcast(Value(17, description: 'first'));
      e.broadcast(Value(36, description: 'second'));

      sc.stream.listen((e) {
        if (e.value == 36) {
          testResult = 36;
        }
      });

      await sc.close();
      expect(testResult, equals(36));
    });

    test('Method toString returns the Event Type name', () {
      var e = Event();
      expect(e.toString(), equals('Event<EventArgs>'));
    });

    // see Issue #5 - Subscribe once and exception
    test('Can Unsubscribe in handler enabling "subscribeOnce" behavior', () {
      var e = Event();
      e.subscribe((args) => e.unsubscribeAll());
      e.broadcast();
      expect(e.subscriberCount, equals(0));
    });
  });
}
