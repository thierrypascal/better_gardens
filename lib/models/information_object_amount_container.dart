import 'package:biodiversity/models/information_object.dart';
import 'package:flutter/cupertino.dart';

/// Container to keep track of the amount of InformationObjects added to someones garden.<br>
/// Only used as a temporary container to keep track over the amount over multiple pages
class InformationObjectAmountContainer extends ChangeNotifier {
  /// Amounts for each InformationObject
  final Map<InformationObject, int> amounts = {};

  /// to which garden the InformationObjects are associated
  String garden;

  /// resets the Container to the initial value
  void clear() {
    garden = null;
    amounts.clear();
  }
}
