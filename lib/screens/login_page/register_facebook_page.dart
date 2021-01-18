import 'package:biodiversity/components/screen_with_logo_and_waves.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterFacebookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LogoAndWavesScreen(
      title: "Registrieren mit Facebook",
      children: [
        ElevatedButton(
          child: Text("Register"),
          onPressed: () => {},
        ),
      ],
    );
  }
}
