import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_storage_provider.dart';

Future<void> setUpBiodiversityEnvironment(
    {@required WidgetTester tester,
    @required Widget widget,
    MockStorageProvider storage}) async {
  await tester.pumpWidget(loadProviders(widget: widget, storage: storage));
  await tester.idle();
}

Widget loadProviders(
    {@required Widget widget,
    MockStorageProvider storage,
    GlobalKey globalKey}) {
  storage ??= MockStorageProvider();
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => User.empty(storageProvider: storage),
        ),
        ChangeNotifierProvider(
          create: (context) => Garden.empty(storageProvider: storage),
        ),
        ChangeNotifierProvider(
            create: (context) => MapInteractionContainer.empty()),
      ],
      child: MaterialApp(
        key: globalKey,
        home: widget,
      ));
}
