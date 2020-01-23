import 'package:event/event.dart';
import 'package:test/test.dart';

void main() {
  group('Event Tests', () {
    // a global variable used to test sender argument in raise method
    var year = 2020;

    // setUp(() {});

    test('Test count correct with no handlers', () {
      var e = Event();
      expect(e.count, equals(0));
    });

    test('Test count correct with added handlers', () {
      var e = Event();
      e + (sender, args) => print('foo');
      e + (sensenderder, args) => print('bar');
      expect(e.count, equals(2));
    });

    test('addHandler adds a handler', () {
      var e = Event();
      e.addHandler((sender, args) => {});
      expect(e.count, equals(1));
    });

    test('"+" operator adds a handler', () {
      var e = Event();
      e + (sender, args) => {};
      expect(e.count, equals(1));
    });

    test('removeHandler removes a handler', () {
      var e = Event();
      var myHandler = (sender, args) => {};

      e.addHandler(myHandler);
      expect(e.count, equals(1));

      var result = e.removeHandler(myHandler);
      expect(result, equals(true));

      result = e.removeHandler(myHandler);
      expect(result, equals(false));

      expect(e.count, equals(0));
    });

    test('"-" removes a handler', () {
      var e = Event();
      var myHandler = (sender, args) => {};

      e.addHandler(myHandler);
      expect(e.count, equals(1));

      var result = e - myHandler;
      expect(result, equals(true));

      result = e - myHandler;
      expect(result, equals(false));

      expect(e.count, equals(0));
    });

    test('raise calls no args handler', () {
      var changedInHandler = -1;

      var e = Event();
      e.addHandler((sender, args) => {changedInHandler = 61});
      e.raise();
      expect(changedInHandler, equals(61));
    });

    test('raise calls a handler with EventArgs', () {
      // a value expected to change when event is raised
      var changedInHandler = -1;

      var e = Event<EventArgs1<int>>();
      e.addHandler((sender, args) => {changedInHandler = args.value});
      e.raise(EventArgs1(39));

      expect(changedInHandler, equals(39));
    });

    test('sender should be null if not using raiseWithSender', () {
      var _sender;

      var e = Event<EmptyEventArgs>();
      e.addHandler((sender, args) => {_sender = sender});
      e.raise();
      expect(_sender, isNull);
    });

    test('sender pattern', () {
      var globalYear = 0;

      // "Sender Event Pattern"
      // 1. declare the Event.
      //    By convention, use an 'Event' suffix for the name
      var changeEvent = Event();

      // 2. Wrap [raiseWithSender] with an on... function.
      //    By convention use an 'on' prefix for the name.
      void onChange(EventArgs args) {
        // Typically the [sender] would be 'this'. A global variable
        // is used in this case because 'this' is not available in a
        // test.
        changeEvent.raiseWithSender(year, args);
      }

      // 3. add a handler (where applicable) to the Event
      changeEvent.addHandler((sender, args) => {globalYear = sender});

      // 4. call the wrapped on... function to raise the Event
      onChange(EmptyEventArgs());

      expect(globalYear, equals(2020));
    });
  });
}
