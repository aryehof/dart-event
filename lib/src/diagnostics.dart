// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

/// Provides logging functionality.
/// ```dart
/// // Add the following once at the start of the program
/// showLog(stdout, Severity.info.value); // could be a file or stdout, any IOSink
///
/// // Somewhere later...
/// log("Some log message", source: "mypackage"); // can set Severity level but `info` is default
///
/// // The log statement is ignored (returns false) if showLog wasn't called
/// // beforehand.
///
/// // see also `Severity` level
/// ```
library diagnostics;

import 'dart:io';

/// Severity levels as a bitmask. Possible values are
/// `debug`, `info`, `warning`, `error`.
/// ```dart
/// // example
/// int severity = Severity.warning.value | Severity.error.value;
///
/// // test for bitmask inclusion
/// bool isError = Severity.hasLevel(_severity, Severity.debug);
/// ```
enum Severity {
  debug(1 << 0), // 1, 1st bit, equivalent to all log messages
  info(1 << 1), // 2, 2nd bit, default log level
  warning(1 << 2), //4, 3rd bit
  error(1 << 3);

  final int value;
  const Severity(this.value);

  /// Returns the value of all levels except for debug, i.e.
  /// Severity.info.value | Severity.warning.value | Severity.error.value
  static int get allExceptDebug {
    return 0xE;
  }

  /// Tests if the bitmask includes the specified Severity level.
  /// ```dart
  /// // example
  /// int bitmask = Severity.info.value | Severity.error.value;
  ///
  /// bool result = Severity.hasLevel(bitmask, Severity.info);  // true
  /// result = Severity.hasLevel(bitmask, Severity.debug);  // false
  /// result = Severity.hasLevel(bitmask, Severity.error);  // true
  /// ```
  static bool hasLevel(int bitmask, Severity level) {
    return (bitmask & level.value) != 0;
  }
}

/// The IO destination log output should be made to.
/// Typically stdout, stderr or a file.
/// If null, indicates log statements should be ignored.
IOSink? _sink;

/// A bitmask representing the Severity.
int _severity = 0;

/// Indicates that diagnostic log statements should be output. Typically,
/// place this statement at the start of your program.
///
/// Expects an IO destination that is normally stdout, stderr or a file,
/// as well as a Severity level.
/// ```dart
/// // example
/// showLog(stdout, Severity.debug.value | Severity.warning.value);
/// ```
void showLog(IOSink outputTo, int level) {
  assert(outputTo != null);
  _sink = outputTo;
  _severity = level;
}

/// Outputs the specified message to the IO destination previously
/// set in `showLog()`.
///
/// Returns true if the message is output, false if not.
///
/// Accepts `source` and `level` arguments that respectively, can be used to
/// identify which library/package/source this message pertains to, and the logging
/// Severity level.
///
/// `source` defaults to "Log", and `Severity.info` is the default log level
///
/// ```dart
/// // example
/// log("This is a message");
///
/// // example with non-default `source` and `level` set
/// log("Another message", source: "MyPackage", level = Severity.warning);
/// ```
bool log(String message, {String source = "Log", Severity level = Severity.info}) {
  if (_sink != null && Severity.hasLevel(_severity, level)) {
    String lvl = level.toString().split('.')[1];
    _sink!.writeln('$source ($lvl): ${DateTime.timestamp()} $message');
    return true;
  }
  return false;
}
