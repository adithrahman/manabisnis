import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:manabisnis/modules/env.dart';

import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';

class WebAuth {


// For registering a new user via web api
  static Future<bool> registerUsingWebApi({
    required User user,
    required String password,
  }) async {
    /* create SHA3 hash for password
        Avaliable `padding`:
        - SHA3_PADDING: for sha3;
        - KECCAK_PADDING: for keccak;
        - SHAKE_PADDING: for shake;
        - CSHAKE_PADDING: for cshake;
    */

    var idHash = SHA3(256, SHA3_PADDING, 256);
    idHash.update(utf8.encode(user.uid));
    var enID = HEX.encode(idHash.digest());
    //print('enID: '+ enID);

    var pwHash = SHA3(256, SHA3_PADDING, 256);
    pwHash.update(utf8.encode(password));
    var enPW = HEX.encode(pwHash.digest());
    //print('enPW: '+ enPW);

    Uri url = new Uri();
    var url_domain = null;
    var platform = Env.getPlatform();

    if (platform == 'WEB') {
      url_domain = Env.URL_DOMAIN_LOCAL;
      platform = 'WEB';
    } else {
      if (platform == 'ANDROID') {
        url_domain = Env.URL_DOMAIN_LOCAL_ANDROID;
        platform = 'ANDROID';
      } else if (platform == 'IOS') {
        // iOS-specific code
      }
    }

    String rawMsg = '{"uid":"'+user.uid+'","email":"'+user.email.toString()+
        '","enID":"'+enID+'","enPW":"'+enPW+
        '","name":"'+user.displayName.toString()+'","phone":"'+user.phoneNumber.toString()+
        '","photo":"'+user.photoURL.toString()+'"}';
    //print('rawMsg: '+ rawMsg);

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodeMsg = stringToBase64.encode(rawMsg);
    //print('enMsg: '+ encodeMsg);

    url = Uri.parse(url_domain + Env.URL_API + "register.php?msg=" + encodeMsg + "&src=" + platform);
    //print('URL: '+ url.toString());

    final response = await http.get(url);
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    var retRes = response.body;

    // if response == null, maybe user exist in server db
    // decode JSON return from the web
    Map<String, dynamic> resp = jsonDecode(retRes);
    if (resp['uid'] == enID) {
      //print('return: ${resp['retVal']}');
      return true;
    }
    return false;

  }

}