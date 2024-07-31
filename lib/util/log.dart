/* Copyright (C) OnePub IP Pty Ltd - All Rights Reserved
 * licensed under the GPL v2.
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:dcli/dcli.dart';

void log(String message) {
  final lmessage = Ansi.strip(message);
  _logout(green(lmessage));
}

void loginfo(String message) {
  final lmessage = Ansi.strip(message);
  _logout(blue(lmessage));
}

void logwarn(String message) {
  final lmessage = Ansi.strip(message);
  _logerr(orange(lmessage));
}

void logerr(String message) {
  final lmessage = Ansi.strip(message);
  _logerr(red(lmessage));
}

void _logout(String message) {
  final args = ParsedArgs();

  var lmessage = message;
  if (!args.colour) {
    lmessage = Ansi.strip(message);
  }

  if (args.useLogfile) {
    args.logfile.append(lmessage);
  } else {
    print(lmessage);
  }
}

class ParsedArgs {
  bool get colour => true;
  bool get useLogfile => false;
  String get logfile => '';

  bool get quiet => false;
}

void _logerr(String message) {
  final args = ParsedArgs();

  var lmessage = message;
  if (!args.colour) {
    lmessage = Ansi.strip(message);
  }

  if (args.useLogfile) {
    args.logfile.append(lmessage);
  } else {
    printerr(lmessage);
  }
}

void overwriteLine(String message) {
  final args = ParsedArgs();
  if (!args.quiet) {
    if (args.useLogfile) {
      log(message);
    } else {
      Terminal().overwriteLine(message);
    }
  }
}
