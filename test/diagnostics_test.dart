// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

import 'package:event/event.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  group('Diagnostic Tests', () {
    test('Severity bitmask inclusion is correct', () {
      int severity = Severity.warning.value | Severity.error.value;

      bool containsErrorLevel = (severity & Severity.error.value) != 0;
      expect(containsErrorLevel, isTrue);

      bool containsDebugLevel = (severity & Severity.debug.value) != 0;
      expect(containsDebugLevel, isFalse);
    });

    test('allExceptDebug is all levels except for debug', () {
      expect(Severity.allExceptDebug,
          equals(Severity.info.value | Severity.warning.value | Severity.error.value));
      // equivalent to 0xE, i.e. 0000_1110
    });

    test('all is every levels', () {
      expect(
          Severity.all,
          equals(Severity.debug.value |
              Severity.info.value |
              Severity.warning.value |
              Severity.error.value));
      // equivalent to 0xF, i.e. 0000_1111
    });

    test('hasLevel allows inclusion of the bitmask to be tested', () {
      int mask = Severity.warning.value | Severity.error.value;

      expect(Severity.hasLevel(mask, Severity.debug), isFalse);
      expect(Severity.hasLevel(mask, Severity.info), isFalse);
      expect(Severity.hasLevel(mask, Severity.warning), isTrue);
      expect(Severity.hasLevel(mask, Severity.error), isTrue);
    });

    test('Logging a debug message with a debug Severity level should output', () {
      showLog(NullIOSink(), Severity.debug.value);

      bool result = log("A debug message with debug level", level: Severity.debug);
      expect(result, isTrue);
    });

    test('Logging a debug message with only a warning Severity level should not output', () {
      showLog(NullIOSink(), Severity.warning.value);

      bool result = log("A debug message, but warning level", level: Severity.debug);
      expect(result, isFalse);
    });
  });
}
