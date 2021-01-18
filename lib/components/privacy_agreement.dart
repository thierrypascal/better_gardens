import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// shows a pop up with the privacy agreement.<br>
/// Returns [true] if the agreement was accepted
Future<bool> showPrivacyAgreement(BuildContext context) async {
  final _privacyAgreement =
      await rootBundle.loadString('res/private-data-agreement.txt');
  final _read = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      insetPadding: const EdgeInsets.all(5),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, "akzeptiert"),
          child: const Text("Akzeptieren"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Schliessen"),
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          children: [
            MarkdownBody(data: _privacyAgreement),
          ],
        ),
      ),
    ),
  );
  return _read != null;
}
