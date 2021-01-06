import 'dart:async';
import 'dart:developer' as logging;

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/user.dart' as biodiversityUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

class GoogleRegister extends StatefulWidget {
  @override
  State createState() => GoogleRegisterState();
}

class GoogleRegisterState extends State<GoogleRegister> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
      logging.log("User ${googleAccount.displayName}");
      final token = await googleAccount.authentication;
      final OAuthCredential credential =
          GoogleAuthProvider.credential(idToken: token.idToken);
      logging.log("1");
      final UserCredential authUser =
          await _auth.signInWithCredential(credential);
      logging.log("2");
      authUser.user.updateProfile(displayName: googleAccount.displayName);
      logging.log("3");
      authUser.user.updateEmail(googleAccount.email);
      logging.log("4");
      Provider.of<biodiversityUser.User>(context, listen: false)
          .updateUserData(newNickname: googleAccount.displayName);
      logging.log("5");
    } catch (error) {
      logging.log("error on loging in: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _handleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      drawer: MyDrawer(),
      body: !Provider.of<biodiversityUser.User>(context).isLoggedIn()
          ? const Center(child: Text("Attepmpting to register with google"))
          : Text("Willkommen!"),
    );
  }
}
