// Copyright 2020 Aryeh Hoffman. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

/// An error that indicates that the argument being [broadcast]
/// does not match the [Event] generic type.
class ArgsError extends TypeError {
  ArgsError(this.message);
  final String message;

  @override
  String toString() {
    return message;
  }
}
