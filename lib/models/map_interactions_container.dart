import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInteractionContainer extends ChangeNotifier {
  String _name;
  String _type;
  LatLng _selectedLocation;

  MapInteractionContainer(this._name, this._type, this._selectedLocation);

  MapInteractionContainer.empty();

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get type => _type;

  set type(String value) {
    _type = value;
    notifyListeners();
  }

  LatLng get selectedLocation => _selectedLocation;

  set selectedLocation(LatLng value) {
    _selectedLocation = value;
    notifyListeners();
  }

  void reset() {
    _name = "";
    _type = "";
    _selectedLocation = null;
    notifyListeners();
  }
}
