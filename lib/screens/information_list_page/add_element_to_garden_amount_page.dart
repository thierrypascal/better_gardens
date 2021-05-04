import 'package:biodiversity/components/edit_dialog.dart';
import 'package:biodiversity/components/simple_information_object_card_widget.dart';
import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/information_object_amount_container.dart';
import 'package:biodiversity/screens/information_list_page/add_element_to_garden_location_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Workflow Add Element To One's Garden: define amount of selected element
class AddElementToGardenAmountPage extends StatefulWidget {
  AddElementToGardenAmountPage({Key key, this.object}) : super(key: key);

  @override
  _AddElementToGardenAmountPageState createState() =>
      _AddElementToGardenAmountPageState();

  ///Selected InformationObject
  final InformationObject object;
}

class _AddElementToGardenAmountPageState
    extends State<AddElementToGardenAmountPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return EditDialog(
      title: "Lebensraum hinzufügen",
      abortCallback: () {
        Provider.of<InformationObjectAmountContainer>(context,
            listen: false).amounts.clear();
        Navigator.pop(context);
      },
      save: "Weiter",
      saveIcon: Icons.navigate_next,
      saveCallback: () {
        _formKey.currentState.save();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddElementToGardenLocationPage()),
        );
      },
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Lebensraum hinzufügen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              "Gib die Menge des Lebensraumes an, den Du hinzufügen möchtest."),
          SizedBox(
            height: 20,
          ),
          SimpleInformationObjectCard(
            widget.object,
            formKey: _formKey,
          ),
        ],
      ),
    );
  }
}
