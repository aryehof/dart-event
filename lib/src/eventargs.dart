// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

/// Represents the (optional) arguments provided to handlers
///  when an [Event] occurs. For example:
///
/// ```
/// class ChangedValue extends EventArgs {
///   int changedValue;
///   ChangedValue(this.changedValue);
/// }
/// ```
abstract class EventArgs {}

/// Represents an empty [EventArgs]. For use where no arguments
/// are required.
class EmptyEventArgs extends EventArgs {}

/// Represents a premade [EventArgs] with one (generic) value.
/// For use as a quick alternative to defining your own custom EventArgs.
class EventArgs1<T> extends EventArgs {
  /// A generic value.
  T value;

  /// Creates a simple  EventArgs with one generic [value]
  EventArgs1(this.value);
}
