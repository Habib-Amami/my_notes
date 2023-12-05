import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  //login methode
  Future logIn({
    required BuildContext ctx,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showAdaptiveDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
          title: Text(e.code.toString().toLowerCase()),
          content: const Text(
              "Something went wrong please check your credentials and re-try!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  //register methode
  Future register({
    required BuildContext ctx,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showAdaptiveDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
          title: Text(e.code.toString().toLowerCase()),
          content: const Text(
              "Something went wrong please check your credentials and re-try!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }
}
