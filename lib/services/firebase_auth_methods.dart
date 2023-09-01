// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/screens/email_auth/home_screen.dart';
import 'package:firebase_series/screens/email_auth/login_screen.dart';
import 'package:firebase_series/utils.dart';
import 'package:flutter/material.dart';

class FirebaseAuthMethods {
  final FirebaseAuth auth;
  FirebaseAuthMethods({required this.auth});

  //EMAIL SIGNUP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
    required void Function(bool) setLoading,
  }) async {
    try {
      if (password == confirmPassword) {
        setLoading(true);
        await auth
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          Utils().toastMessage(
              'Account Created! Login with the same credentials.');
          setLoading(false);
          // Timer(const Duration(seconds: 3), () {
          //   sendEmailVerification(context);
          // });

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }).onError((error, stackTrace) {
          Utils().toastMessage(error.toString());
          setLoading(false);
        });
      } else {
        //showSnackBar(context, 'Passwords did not match');
        Utils().toastMessage('Passwords did not match.');
      }
    } on FirebaseAuthException catch (e) {
      // showSnackBar(context, e.message!);
      Utils().toastMessage(e.message!);
    }
  }

  //EMAIL SIGNIN
  Future<void> signInWitHEmail({
    required String email,
    required String password,
    required BuildContext context,
    required void Function(bool) setLoading,
  }) async {
    try {
      setLoading(true);
      await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        Utils().toastMessage('login Successfull.');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
        // if (!auth.currentUser!.emailVerified) {
        //   await sendEmailVerification(context);
        // }
        print('ABCD');
        setLoading(false);
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils().toastMessage(error.toString());
      });
      print('ABCDEEEEE');
      //showSnackBar(context, 'Login Successfully.');
    } on FirebaseAuthException catch (e) {
      //showSnackBar(context, e.message!);
      Utils().toastMessage(e.message!);
    }
  }

  //EMAIL VERIFICATION
  // Future<void> sendEmailVerification(BuildContext context) async {
  //   try {
  //     auth.currentUser!.sendEmailVerification();
  //     Utils().toastMessage(
  //         'Check your email, we have sent you a verification link to verify your account.');
  //     //showSnackBar(context, 'Email Verification sent!');
  //   } on FirebaseAuthException catch (e) {
  //     //showSnackBar(context, e.message!);
  //     Utils().toastMessage(e.message!);
  //   }
  // }

  //PHONE NUMBER VERIFICATION
  // Future<void> signInWithPhoneNumber(
  //     {required BuildContext context, required String phoneNumber}) async {
  //   TextEditingController codeController = TextEditingController();
  //   //Works only in Android and IOS
  //   await auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     //verificationCompleted is only works in Android.
  //     //Automatically signsin in Android and didnt ask user to write OTP.
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await auth.signInWithCredential(credential);
  //       debugPrint('PhoneAuthCredential: $credential');
  //     },
  //     verificationFailed: (error) => Utils().toastMessage(error.message!),
  //     codeSent: (verificationId, forceResendingToken) async {
  //       // showOTPDialog(
  //       //   context: context,
  //       //   codeController: codeController,
  //       //   onPressed: () async {
  //       //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       //         verificationId: verificationId,
  //       //         smsCode: codeController.text.trim());
  //       //     await auth.signInWithCredential(credential);
  //       //     debugPrint('PhoneAuthCredential: $credential');
  //       //     Navigator.of(context).pop();
  //       //   },
  //       // );
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) {},
  //   );
  // }
}
