import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/information_object_amount_container.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// same as expandable_information_object_card_widget.dart, but with less infos,
/// not expandable
class SimpleInformationObjectCard extends StatelessWidget {
  /// the [InformationObject] to display
  final InformationObject object;

  ///if amount is changeable by user
  final bool amountLocked;

  ///if amount is given
  final int amount;

  /// if on tap onto the element the page should be redirected to SelectionList
  final Function onTapHandler;

  /// additional Info to be displayed
  final String additionalInfo;

  final ServiceProvider _serviceProvider;

  /// formKey to control the amount input field
  final GlobalKey<FormState> formKey;

  /// Non expandable ListTile, displaying a [BiodiversityMeasure]
  SimpleInformationObjectCard(this.object,
      {this.onTapHandler,
      this.additionalInfo,
      this.amountLocked,
      this.amount,
      ServiceProvider serviceProvider,
      this.formKey,
      Key key})
      : _serviceProvider = serviceProvider ?? ServiceProvider.instance,
        super(key: key);

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
                ],
              ),
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: Form(
                key: formKey,
                child: TextFormField(
                  readOnly: amountLocked == true ? true : false,
                  initialValue: amount != null ? amount.toString() : "1",
                  decoration: InputDecoration(
                      labelText: "Menge", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      Provider.of<InformationObjectAmountContainer>(context,
                              listen: false)
                          .amounts
                          .putIfAbsent(object, () => int.tryParse(value)),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
            ),
            if (additionalInfo != null)
              Text(
                additionalInfo,
                softWrap: true,
                maxLines: 4,
                overflow: TextOverflow.fade,
              ),
            Container(
              child: _serviceProvider.imageService
                  .getImage(object.name, object.type, height: 60, width: 60),
            )
          ],
        ),
      ),
    );
  }
}
