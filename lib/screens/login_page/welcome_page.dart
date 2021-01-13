import 'dart:core';

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
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
          ),
        ));
  }
}
