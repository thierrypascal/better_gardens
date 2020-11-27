import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInteractionContainer extends ChangeNotifier {
  BiodiversityMeasure _element;
  LatLng _selectedLocation;

  MapInteractionContainer(this._element, this._selectedLocation);

  MapInteractionContainer.empty();

  BiodiversityMeasure get element => _element;

  LatLng get selectedLocation => _selectedLocation;

  String get type => _element != null ? _element.type : "";

  set element(BiodiversityMeasure element) {
    _element = element;
    notifyListeners();
  }

  set selectedLocation(LatLng value) {
    _selectedLocation = value;
    notifyListeners();
  }

  void reset() {
    _element = null;
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
