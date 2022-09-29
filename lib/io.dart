// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dcli/dcli.dart';

/// Environment variable you can set to alter the location
/// of the dart/.config dir for testing pruposes.
const pubTestsConfigDirKey = '_PUB_TEST_CONFIG_DIR';

/// The location for dart-specific configuration.
///
/// `null` if no config dir could be found.
final String? dartConfigDir = () {
  String? configDir;
  if (runningFromTest && env.exists('_PUB_TEST_CONFIG_DIR')) {
    configDir = env['_PUB_TEST_CONFIG_DIR'];
  } else {
    if (!env.exists("HOME")) {
      return null;
    }
    configDir = applicationConfigHome('dart');
  }

  if (configDir == null) {
    return null;
  }
  if (!exists(configDir)) {
    createDir(configDir, recursive: true);
  }
  return configDir;
}();

String applicationConfigHome(String productName) =>
    join(HOME, '.config', productName);

/// Whether the current process is a pub subprocess being run from a test.
///
/// The "_PUB_TESTING" variable is automatically set for all the test code's
/// invocations of pub.
final bool runningFromTest = env.exists('_PUB_TESTING') && _assertionsEnabled;

final bool _assertionsEnabled = () {
  try {
    assert(false, 'Check if asserts enabled');
    // ignore: avoid_catching_errors
  } on AssertionError {
    return true;
  }
  return false;
}();
