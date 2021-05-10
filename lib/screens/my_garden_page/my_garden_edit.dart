import 'dart:typed_data';

import 'package:biodiversity/components/edit_dialog.dart';
import 'package:biodiversity/components/select_image_for_garden.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/screens/map_page/maps_submap_widget.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MyGardenEdit extends StatefulWidget {
  MyGardenEdit({Key key}) : super(key: key);

  String _toDeleteURL;
  bool _deleteRequested = false;
  bool _saveRequested = false;
  Uint8List _toSaveImage;

  @override
  _MyGardenEditState createState() => _MyGardenEditState();
}

class _MyGardenEditState extends State<MyGardenEdit> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _gartenType = '';
  String _selectedType;
  String _address;
  var _gardenType = [
    'Familiengarten',
    'Hausgarten',
    'Dachgarten',
    'Balkon / Terrase',
    'Gemeinschaftsgarten',
    'Innenhof'
  ];

  @override
  Widget build(BuildContext context) {
    final garden = Provider.of<Garden>(context, listen: false);
    if (garden.gardenType != null && _gardenType.contains(garden.gardenType)) {
      _selectedType = garden.gardenType;
    }
    try {
      Provider.of<MapInteractionContainer>(context, listen: false)
          .getLocationOfAddress(garden.street)
          .then((result) =>
      Provider
          .of<MapInteractionContainer>(context, listen: false)
          .selectedLocation = result);
    } catch (e) {
      Provider
          .of<MapInteractionContainer>(context, listen: false)
          .selectedLocation = const LatLng(46.948915, 7.445423);
    }

    return EditDialog(
      title: ('Mein Garten'),
      abortCallback: () {
        Navigator.of(context).pop();
      },
      saveCallback: () async {
        if (widget._saveRequested) {
          garden.imageURL = await ServiceProvider.instance.imageService
              .uploadImage(widget._toSaveImage, 'gardenpictures',
              filename: '${garden.name}_${const Uuid().v4()}');
        }
        if (widget._deleteRequested) {
          ServiceProvider.instance.imageService.deleteImage(
              imageURL: widget._toDeleteURL, bucket: 'gardenpictures');
        }
        //update Image & delete old if necessary
        _formKey.currentState.save();
        garden.name = _name;
        garden.street = _address;
        garden.gardenType = _gartenType;
        garden.saveGarden();
        Navigator.of(context).pop();
      },
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(garden.name + ' bearbeiten',
                  style: const TextStyle(fontSize: 20.0)),

              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: TextFormField(
                  initialValue: garden.name,
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
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                      onChanged: (String _value) =>
                      {
                        setState(() {
                          _gartenType = _value;
                          _selectedType = _value;

                          print(_value);
                        }),
                      },
                      hint: Text('Select your garden type'),
                    ),
                  ),
                ),
              ),

              const SizedBox(),

              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: TextFormField(
                  initialValue: garden.street,
                  decoration: const InputDecoration(
                      labelText: 'Garten Adresse',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) {
                    _address = value;
                  },
                  onChanged: (value) {
                    try {
                      Provider.of<MapInteractionContainer>(context,
                          listen: false)
                          .getLocationOfAddress(value)
                          .then((result) =>
                      Provider
                          .of<MapInteractionContainer>(context,
                          listen: false)
                          .selectedLocation = result);
                    } catch (e) {
                      Provider
                          .of<MapInteractionContainer>(context,
                          listen: false)
                          .selectedLocation = const LatLng(46.948915, 7.445423);
                    }
                  },
                ),
              ),
              select_garden_image(
                deleteFunction: (toDeleteURL) {
                  widget._toDeleteURL = toDeleteURL;
                  widget._deleteRequested = true;
                },
                saveFunction: (imageFile) {
                  setState(() {
                    widget._toSaveImage = imageFile;
                    widget._saveRequested = true;
                  });
                  Navigator.of(context).pop();
                },
                toSaveImage: widget._toSaveImage,
                garden: garden,
              ),
              //Show mianimap of Garden
              SubMap(),
            ],
          ),
        ),
      ),
    );
  }
}

