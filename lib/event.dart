// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

/// Represents an [Event] as some number of handlers (subscribers) that can be
/// notified when a condition occurs.
///
/// See also [EventArgs].
library event;

export 'src/event.dart' show Event;
export 'src/eventargs.dart' show EventArgs, Value, Values;
export 'src/diagnostics.dart' show showLog, log, Severity;
