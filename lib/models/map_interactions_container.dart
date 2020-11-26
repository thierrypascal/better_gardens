import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInteractionContainer extends ChangeNotifier {
  String _name;
  String _type;
  LatLng _selectedLocation;

  MapInteractionContainer(this._name, this._type, this._selectedLocation);

  MapInteractionContainer.empty();

  String get name => _name;

  String get type => _type;

  LatLng get selectedLocation => _selectedLocation;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set type(String value) {
    _type = value;
    notifyListeners();
  }

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

  Future<String> getAddressOfSelectedLocation() async {
    if (_selectedLocation == null) {
      return "Keine Adresse ausgewählt";
    }
    final List<Placemark> placeMark = await placemarkFromCoordinates(
        _selectedLocation.latitude, _selectedLocation.longitude);
    return "${placeMark[0].street}, ${placeMark[0].locality}";
  }

  CameraPosition getCameraPosition() {
    return CameraPosition(
        zoom: 18.0,
        target: _selectedLocation ?? const LatLng(46.948915, 7.445423));
  }
}
