import 'dart:ui';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// same as expandable_information_object_card_widget.dart, but with less infos,
/// not expandable
class SimpleInformationObjectCard extends StatelessWidget {
  /// the [InformationObject] to display
  final InformationObject object;

  /// if on tap onto the element the page should be redirected to SelectionList
  final Function onTapHandler;

  /// Non expandable ListTile, displaying a [BiodiversityMeasure]
  const SimpleInformationObjectCard(this.object, {this.onTapHandler, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapHandler,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
            color: const Color.fromRGBO(200, 200, 200, 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(object.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  if (object.associationMap.values.isNotEmpty)
                    Text(object.associationMap.keys.first +
                        ' ' +
                        _generateCommaSeparatedString(
                            object.associationMap.values.first)),
                ],
              ),
            ),
            ServiceProvider.instance.imageService
                .getImage(object.name, object.type, height: 60, width: 60)
          ],
        ),
      ),
    );
  }

  String _generateCommaSeparatedString(List<InformationObject> items) {
    final sb = StringBuffer();
    for (final item in items) {
      sb.write(item.name);
      sb.write(', ');
    }
    return sb.toString().replaceRange(sb.length - 2, sb.length, '');
  }
}
