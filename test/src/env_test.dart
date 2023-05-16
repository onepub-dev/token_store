/* Copyright (C) OnePub IP Pty Ltd - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:dcli/dcli.dart' hide Settings;
import 'package:dcli/dcli.dart' as dcli;
import 'package:test/test.dart';
import 'package:token_store/token_store.dart';

void main() {
  test('dbpool ...', () async {
    var dirName = '/tmp/1';
    await withEnvironment(() async {
      print('path $dirName');
      print('env ${env.HOME}');

      TokenStore()
          .addCredential(Credential.token(Uri.parse('www.test.1'), '1111'));

      'echo $HOME'.run;
      'find $HOME'.run;
      'dart pub token list'.run;
    }, environment: {'HOME': dirName, 'PUB_CACHE': PubCache().cacheDir});

    dirName = '/tmp/2';
    await withEnvironment(() async {
      print('path $dirName');
      print('env ${env.HOME}');

      TokenStore()
          .addCredential(Credential.token(Uri.parse('www.test.2'), '2222'));

      'echo $HOME'.run;
      'find $HOME'.run;
      'dart pub token list'.run;
    }, environment: {'HOME': dirName, 'PUB_CACHE': PubCache().cacheDir});
  });
}
