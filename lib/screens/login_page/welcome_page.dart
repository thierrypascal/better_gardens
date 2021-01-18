import 'dart:core';

import 'package:biodiversity/components/screen_with_logo_and_waves.dart';
import 'package:biodiversity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page to redirect the user after the login.
/// It shows some basic infos
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LogoAndWavesScreen(
      title: "Willkommen",
      children: [
        Text(
          "Hallo ${Provider.of<User>(context).nickname}",
          style: const TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        if (!Provider.of<User>(context).hasConfirmedEmail)
          const Text("Bitte bestätige deine Email Adresse "
              "mit dem Link den du per Email bekommen hast."),
      ],
    );
  }
}
