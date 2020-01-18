import 'eventargs.dart';

typedef EventHandler<ArgsType extends EventArgs> = void Function(Object sender, ArgsType a);

// typedef Action = void Function();
// typedef Action1<T1> = void Function(T1 arg1);
// typedef Action2<T1, T2> = void Function(T1 arg1, T2 arg2);
// typedef Action3<T1, T2, T3> = void Function(T1 arg1, T2 arg2, T3 arg3);

class Event<ArgsType extends EventArgs> {
  final List<EventHandler<ArgsType>> _handlers = [];

  void addHandler(EventHandler<ArgsType> handler) {
    _handlers.add(handler);
  }

  /// add a handler for the event
  void operator <(EventHandler<ArgsType> handler) {
    addHandler(handler);
  }

  void removeHandler(EventHandler<ArgsType> handler) {
    _handlers.remove(handler);
  }

  void dispose() {
    // TODO
  }

  void raise([ArgsType args]) {
    assert(_handlers != null);

    if (_handlers != null) {
      for (var handler in _handlers) {
        handler(this, args);
      }
    }
  }
}
