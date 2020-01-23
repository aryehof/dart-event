/// Represents an [Event] as some number of handlers (subscribers) that can be
/// notified when a condition occurs.
///
/// See also [EventArgs].
///
/// ```
/// // declare an event with no arguments
/// final onValueChanged = Event();
///
/// // alternative example of an event expecting an argument (see [EventArgs])
/// final onValueChanged = Event<ChangedValue>();
/// counter.onValueChanged + (source, args) => print(args.changedValue); // add a handler
/// onValueChanged.raise(ChangedValue(value)); // raise the [Event] to have handlers called
/// ```
library event;

export 'src/event.dart';
export 'src/eventargs.dart';
