import 'dart:core';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Env {
  static String URL_DOMAIN_LOCAL = 'http://127.0.0.1/bisnisku/';
  static String URL_DOMAIN_LOCAL_ANDROID = 'http://10.0.2.2/bisnisku/';
  static String URL_DOMAIN_LOCAL_IOS = 'http://127.0.0.1/bisnisku/';

  static String URL_DOMAIN = 'http://0.0.0.0/bisnisku/';
  static String URL_API = 'api/';
  //var URL_API = Uri.https('http://127.0.0.1/', 'bisnisku/api/', {'q': '{http}'});

  static String COPYRIGHT = 'Copyright © 2021, Bisnisku, Inc.';

  static String getPlatform() {

    if (kIsWeb) {
      return 'WEB';
    } else {
      if (Platform.isAndroid) {
        return 'ANDROID';
      } else if (Platform.isIOS) {
        return 'IOS';
      } else if (Platform.isFuchsia) {
        return 'FUCHSIA';
      } else {
        return 'UNKNOWN';
      }
    }

  }
}