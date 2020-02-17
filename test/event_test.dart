import 'package:event/event.dart';
import 'package:test/test.dart';

void main() {
  group('Event Tests', () {
    // setUp(() {});

    test('Test count correct with no handlers', () {
      var e = Event();
      expect(e.subscriberCount, equals(0));
    });

    test('Test count correct with added handlers', () {
      var e = Event();
      e + (args) => print('foo');
      e + (args) => print('bar');
      expect(e.subscriberCount, equals(2));
    });

    test('addHandler adds a handler', () {
      var e = Event();
      e.subscribe((args) => {});
      expect(e.subscriberCount, equals(1));
    });

    test('"+" operator adds a handler', () {
      var e = Event();
      e + (args) => {};
      expect(e.subscriberCount, equals(1));
    });

    test('removeHandler removes a handler', () {
      var e = Event();
      var myHandler = (args) => {};

      e.subscribe(myHandler);
      expect(e.subscriberCount, equals(1));

      var result = e.unsubscribe(myHandler);
      expect(result, equals(true));

      result = e.unsubscribe(myHandler);
      expect(result, equals(false));

      expect(e.subscriberCount, equals(0));
    });

    test('"-" removes a handler', () {
      var e = Event();
      var myHandler = (args) => {};

      e.subscribe(myHandler);
      expect(e.subscriberCount, equals(1));

      var result = e - myHandler;
      expect(result, equals(true));

      result = e - myHandler;
      expect(result, equals(false));

      expect(e.subscriberCount, equals(0));
    });

    test('broadcast calls no args handler', () {
      var changedInHandler = -1;

      var e = Event();
      e.subscribe((args) => {changedInHandler = 61});
      e.broadcast();
      expect(changedInHandler, equals(61));
    });

    test('broadcast calls a handler with EventArgs', () {
      // a value expected to change when event is raised
      var changedInHandler = -1;

      var e = Event<GenericEventArgs1<int>>();
      e.subscribe((args) => {changedInHandler = args.value});
      e.broadcast(GenericEventArgs1(39));

      expect(changedInHandler, equals(39));
    });

    test('StdEventArg fields - whenOccurred and description', () {
      DateTime eventOccurred;
      String description;

      var e = Event<StdEventArgs>();
      e.subscribe((args) {
        eventOccurred = args.whenOccurred;
        description = args.description;
      });
      e.broadcast(StdEventArgs(description: 'test description'));
      expect(DateTime.now().difference(eventOccurred), lessThan(Duration(milliseconds: 250)));
      expect(description, equals('test description'));
    });
    test('EventArgs1', () {
      String value;

      var e = Event<GenericEventArgs1<String>>();
      e.subscribe((args) => value = args.value);
      e.broadcast(GenericEventArgs1('hello'));
      expect(value, equals('hello'));
    });

    test('EventArgs2', () {
      String value1;
      int value2;

      var e = Event<GenericEventArgs2<String, int>>();
      e.subscribe((args) {
        value1 = args.value1;
        value2 = args.value2;
      });
      e.broadcast(GenericEventArgs2('boom', 37));
      expect(value1, equals('boom'));
      expect(value2, equals(37));
    });

    test('wrapped Event pattern', () {
      var currentYear = 2020;
      var changedTo;

      // "wrapped Event Pattern"
      // 1. declare the Event.
      //    By convention, use an 'Event' suffix for the name.
      var changeEvent = Event<GenericEventArgs1>();

      // 2. Wrap [broadcastWithContext] with an on... function.
      //    By convention use an '_on' prefix for the name.
      //    This is called to broadcast the Event to subscribers.
      void _onChange() {
        // Typically the [context] would be 'this'. A global variable
        // is used in this case because 'this' is not available in a
        // test.
        // changeEvent.broadcastWithContext(year, args);

        changeEvent.broadcast(GenericEventArgs1(currentYear));
      }

      // 3. add a handler (where applicable) to the Event
      changeEvent.subscribe((args) => changedTo = args.value);

      // 4. call the wrapped on... function to raise the Event
      _onChange();

      expect(changedTo, equals(2020));
    });
  });
}
