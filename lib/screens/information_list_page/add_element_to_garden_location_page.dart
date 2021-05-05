import 'package:biodiversity/components/edit_dialog.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/information_object_amount_container.dart';
import 'package:biodiversity/screens/information_list_page/add_element_to_garden_overview_page.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Workflow Add Element To One's Garden: define location of selected element/to which garden it will be added
class AddElementToGardenLocationPage extends StatefulWidget {
  AddElementToGardenLocationPage({Key key}) : super(key: key);

  @override
  _AddElementToGardenLocationPageState createState() =>
      _AddElementToGardenLocationPageState();
}

class _AddElementToGardenLocationPageState
    extends State<AddElementToGardenLocationPage> {
  List<Garden> gardens = [];
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();

    gardens = ServiceProvider.instance.gardenService.getAllGardensFromUser();
    isSelected = List.generate(gardens.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return EditDialog(
      title: "Lebensraum hinzufügen",
      abort: "Zurück",
      abortIcon: Icons.navigate_before,
      abortCallback: () {
        Navigator.pop(context);
      },
      save: "Weiter",
      saveIcon: Icons.navigate_next,
      saveCallback: () {
        if (isSelected.isNotEmpty && gardens.isNotEmpty) {
          //get selected element
          int selected;
          Garden selectedGarden;
          selected = isSelected.indexWhere((element) => element == true);
          if (selected != -1) {
            selectedGarden = gardens.elementAt(selected);
            if (ServiceProvider.instance.gardenService
                    .getAllGardensFromUser()
                    .isEmpty ||
                selectedGarden == null) {
              //save to provider
              Provider.of<InformationObjectAmountContainer>(context,
                      listen: false)
                  .garden = selectedGarden;
              //redirect to overview
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddElementToGardenOverviewPage()),
              );
            } else {
              _showMyDialog();
            }
          } else {
            _showMyDialog();
          }
        } else {
          _showMyDialog();
        }
      },
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Lebensraum hinzufügen",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
                "Wähle den Garten, in dem Du den Lebensraum hinzufügen möchtest."),
            const SizedBox(
              height: 20,
            ),
            (gardens.isNotEmpty)
                ? Container(
                    width: double.infinity,
                    child: ToggleButtons(
                        direction: Axis.vertical,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        onPressed: (int index) {
                          setState(() {
                            for (int indexBtn = 0;
                                indexBtn < isSelected.length;
                                indexBtn++) {
                              if (indexBtn == index) {
                                isSelected[indexBtn] = true;
                              } else {
                                isSelected[indexBtn] = false;
                              }
                            }
                          });
                        },
                        isSelected: isSelected,
                        children: List.generate(gardens.length, (index) {
                          return Center(
                              child: Text(gardens.elementAt(index).name));
                        })),
                  )
                : Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Todo: redirect to MyGardenCreate
                        setState(() {});
                      },
                      child: Text("Erstelle einen Garten"),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vorsicht'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Erstelle und wähle zuerst einen Garten aus.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Verstanden'),
            ),
          ],
        );
      },
    );
  }
}
