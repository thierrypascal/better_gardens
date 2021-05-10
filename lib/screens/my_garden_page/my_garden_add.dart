import 'dart:typed_data';

import 'package:biodiversity/components/edit_dialog.dart';
import 'package:biodiversity/components/select_image_for_garden.dart';
import 'package:biodiversity/components/white_redirect_page.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/map_page/maps_submap_widget.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_page.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

///creates a new garden for the user
class MyGardenAdd extends StatefulWidget {
  ///MyGardenAdd constructor
  MyGardenAdd({Key key}) : super(key: key);

  @override
  _MyGardenAddState createState() => _MyGardenAddState();
}

class _MyGardenAddState extends State<MyGardenAdd> {
  final _formKey = GlobalKey<FormState>();
  String _toDeleteURL;
  bool _deleteRequested = false;
  Uint8List _toSaveImage;
  bool _saveRequested = false;
  String _name;
  String _gartenType = '';
  String _selectedType;
  String _address;
  final _gardenType = [
    'Familiengarten',
    'Hausgarten',
    'Dachgarten',
    'Balkon / Terrase',
    'Gemeinschaftsgarten',
    'Innenhof'
  ];

  @override
  Widget build(BuildContext context) {
    final garden = Garden.empty();

    return EditDialog(
      title: ('Mein Garten'),
      abortCallback: () {
        Navigator.of(context).pop();
      },
      saveCallback: () async {
        final selLoc =
            Provider.of<MapInteractionContainer>(context, listen: false)
                .selectedLocation;
        if (_saveRequested) {
          garden.imageURL = await ServiceProvider.instance.imageService
              .uploadImage(_toSaveImage, 'gardenpictures',
                  filename: '${garden.name}_${const Uuid().v4()}');
        }
        if (_deleteRequested) {
          ServiceProvider.instance.imageService
              .deleteImage(imageURL: _toDeleteURL);
        }
        _formKey.currentState.save();
        final user = Provider.of<User>(context, listen: false);
        if (user.gardens.contains(_name)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Du hast bereits einen Garten mit dem namen $_name.\n'
                'Wähle bitte einen anderen.'),
          ));
        } else {
          garden.name = _name;
          garden.street = _address;
          garden.gardenType = _gartenType;
          garden.owner = user.userUUID;
          garden.coordinates = (selLoc != null)
              ? GeoPoint(selLoc.latitude, selLoc.longitude)
              : const GeoPoint(0, 0);
          garden.saveGarden();
          user.addGarden(garden);
          Provider.of<Garden>(context, listen: false).switchGarden(garden);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => WhiteRedirectPage(
                    'Der Garten $_name wurde erstellt.',
                    MyGarden(),
                    duration: 2,
                  )));
        }
      },
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Garten hinzufügen', style: TextStyle(fontSize: 20.0)),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Spitzname Garten',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _name = value,
                ),
              ),
              const SizedBox(),

              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 5.0),
                child: Text('Gartentyp'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedType,
                      items: _gardenType.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (String _value) => {
                        setState(() {
                          _gartenType = _value;
                          _selectedType = _value;
                          print(_value);
                        }),
                      },
                      hint: const Text('Garten auswählen'),
                    ),
                  ),
                ),
              ),

              const SizedBox(),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Garten Adresse',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) {
                    _address = value;
                  },
                  onChanged: (value) {
                    Provider.of<MapInteractionContainer>(context, listen: false)
                        .getLocationOfAddress(value)
                        .then((result) => Provider.of<MapInteractionContainer>(
                                context,
                                listen: false)
                            .selectedLocation = result);
                  },
                ),
              ),

              select_garden_image(
                deleteFunction: (toDeleteURL) {
                  _toDeleteURL = toDeleteURL;
                  _deleteRequested = true;
                },
                saveFunction: (imageFile) {
                  setState(() {
                    _toSaveImage = imageFile;
                    _saveRequested = true;
                  });
                  Navigator.of(context).pop();
                },
                toSaveImage: _toSaveImage,
                garden: garden,
              ),
              //Show minimap of Garden
              SubMap(),
            ],
          ),
        ),
      ),
    );
  }
}
