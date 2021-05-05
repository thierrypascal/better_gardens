import 'package:biodiversity/components/edit_dialog.dart';
import 'package:biodiversity/components/simple_information_object_card_widget.dart';
import 'package:biodiversity/components/white_redirect_page.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/information_object_amount_container.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/screens/information_list_page/add_element_to_garden_location_page.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_elements_list_page.dart';
import 'package:biodiversity/screens/map_page/maps_submap_widget.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Workflow Add Element To One's Garden: overview before saving the added element
class AddElementToGardenOverviewPage extends StatefulWidget {
  AddElementToGardenOverviewPage({Key key}) : super(key: key);

  @override
  _AddElementToGardenOverviewPageState createState() =>
      _AddElementToGardenOverviewPageState();
}

class _AddElementToGardenOverviewPageState
    extends State<AddElementToGardenOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return EditDialog(
      title: "Lebensraum hinzufügen",
      abort: "Zurück",
      abortIcon: Icons.navigate_before,
      abortCallback: () {
        Navigator.pop(context);
      },
      saveCallback: () {
        //save amount and element to selected garden
        Provider.of<Garden>(context, listen: false).addOwnedObject(
            Provider.of<InformationObjectAmountContainer>(context,
                    listen: false)
                .amounts
                .keys
                .first
                .name,
            Provider.of<InformationObjectAmountContainer>(context,
                    listen: false)
                .amounts
                .values
                .first);
        Provider.of<Garden>(context, listen: false).saveGarden();

        //clear the container
        Provider.of<InformationObjectAmountContainer>(context, listen: false)
            .amounts
            .clear();

        //redirect back to list
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WhiteRedirectPage(
                  "Element gespeichert und hinzugefügt",
                  BiodiversityElementListPage())),
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
          SizedBox(height: 10),
          Text("Element bestätigen."),
          SizedBox(height: 20),
          SimpleInformationObjectCard(
            Provider.of<InformationObjectAmountContainer>(context,
                    listen: false)
                .amounts
                .keys
                .first,
            amountLocked: true,
            amount: Provider.of<InformationObjectAmountContainer>(context,
                    listen: false)
                .amounts
                .values
                .first,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(IconsBiodiversity.wish),
              Text(" Gewählter Garten: " +
                  Provider.of<InformationObjectAmountContainer>(context,
                          listen: false)
                      .garden
                      .name),
            ],
          ),
          SizedBox(height: 20),
          SubMap(),
        ],
      ),
    );
  }
}
