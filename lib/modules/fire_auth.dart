import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:manabisnis/modules/web_auth.dart';

class FireAuth {

  // For registering a new user
  static Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode)
      print("phone: "+ phone);
      user = userCredential.user;
      await user!.updateDisplayName(name);
      //await user!.updatePhoneNumber(phoneCredential)
      await user.reload();
      user = auth.currentUser;

      // now store into mysql db
      if (user != null) {
        //print('try mysql db');

        await WebAuth.registerUsingWebApi(user: user, password: password);

        //print('end try mysql db');
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }


  // For registering a new user
  static Future<User?> registerUsingPhone({
    required String cc,
    required String phone,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user; AuthCredential _phoneAuthCredential;
    int _code;

    await auth.verifyPhoneNumber(
      phoneNumber: cc + phone,
      timeout: Duration(milliseconds: 60000), // 1 min
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
    );

    return user;
  }

  static Future<bool> resetPassword({required String email, required BuildContext ctx}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
      return false;
    }

  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

}