import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// container class to manage map interactions over different screens.
class MapInteractionContainer extends ChangeNotifier {
  BiodiversityMeasure _element;
  LatLng _selectedLocation;

  /// creates a new Container with a element at a given location
  MapInteractionContainer(this._element, this._selectedLocation);

  /// creates an empty Container
  MapInteractionContainer.empty();

  /// returns a [BiodiversityMeasure] object of the stored element
  BiodiversityMeasure get element => _element;

  /// returns a [LatLng] object of the stored location
  LatLng get selectedLocation => _selectedLocation;

  /// returns the type of the stored element
  String get type => _element != null ? _element.type : '';

  set element(BiodiversityMeasure element) {
    _element = element;
    notifyListeners();
  }

  set selectedLocation(LatLng value) {
    _selectedLocation = value;
    notifyListeners();
  }

  /// resets the container to null
  void reset() {
    _element = null;
    _selectedLocation = null;
    notifyListeners();
  }

  /// returns the address of the stored coordinates as string.
  /// a default message is returned if no coordinates are stored
  Future<String> getAddressOfSelectedLocation() async {
    if (_selectedLocation == null) {
      return 'Keine Adresse ausgewählt';
    }
    final placeMark = await placemarkFromCoordinates(
        _selectedLocation.latitude, _selectedLocation.longitude);
    return '${placeMark[0].street}, ${placeMark[0].locality}';
  }

  /// returns the address of the stored coordinates as string.
  /// a default message is returned if no coordinates are stored
  Future<LatLng> getLocationOfAddress(String adr) async {
    var result = const LatLng(46.948915, 7.445423);
    try {
      final location = await locationFromAddress(adr);
      result = LatLng(location.first.latitude, location.first.longitude);
    } catch (e) {
      return result;
    }
    return result;
  }

  /// returns a [CameraPosition] which has the stored location in focus
  CameraPosition getCameraPosition() {
    return CameraPosition(
        zoom: 18.0,
        target: _selectedLocation ?? const LatLng(46.948915, 7.445423));
  }
}
