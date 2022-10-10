// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli_util/cli_util.dart';
import 'package:dcli/dcli.dart';

/// Environment variable you can set to alter the location
/// of the dart/.config dir for testing pruposes.
const pubTestsConfigDirKey = '_PUB_TEST_CONFIG_DIR';

/// The location for dart-specific configuration.
///
/// `null` if no config dir could be found.
String? get dartConfigDir {
  String? configDir;
  if (runningFromTest && env.exists('_PUB_TEST_CONFIG_DIR')) {
    configDir = env['_PUB_TEST_CONFIG_DIR'];
  } else {
    try {
      configDir = applicationConfigHome('dart');
    } on EnvironmentNotFoundException catch (_, __) {
      return null;
    }
  }

  if (configDir == null) {
    return null;
  }
  if (!exists(configDir)) {
    createDir(configDir, recursive: true);
  }
  return configDir;
}

String applicationConfigHome(String productName) =>
    join(_configHome, productName);

String get _configHome {
  if (Platform.isWindows) {
    final appdata = env['APPDATA'];
    if (appdata == null) {
      throw EnvironmentNotFoundException(
          'Environment variable %APPDATA% is not defined!');
    }
    return appdata;
  }

  if (Platform.isMacOS) {
    return join(_home, 'Library', 'Application Support');
  }

  if (Platform.isLinux) {
    final xdgConfigHome = Platform.environment['XDG_CONFIG_HOME'];
    if (xdgConfigHome != null) {
      return xdgConfigHome;
    }
    // XDG Base Directory Specification says to use $HOME/.config/ when
    // $XDG_CONFIG_HOME isn't defined.
    return join(_home, '.config');
  }

  // We have no guidelines, perhaps we should just do: $HOME/.config/
  // same as XDG specification would specify as fallback.
  return join(_home, '.config');
}

String get _home {
  final home = env['HOME'];
  if (home == null) {
    throw EnvironmentNotFoundException(
        'Environment variable \$HOME is not defined!');
  }
  return home;
}

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
