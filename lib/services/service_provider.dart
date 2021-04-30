import 'package:biodiversity/services/biodiversity_service.dart';
import 'package:biodiversity/services/garden_service.dart';
import 'package:biodiversity/services/image_service.dart';
import 'package:biodiversity/services/map_marker_service.dart';
import 'package:biodiversity/services/species_service.dart';
import 'package:biodiversity/services/take_home_message_service.dart';

/// A class which provides a single place where all services can be accessed
class ServiceProvider {
  ServiceProvider._privateConstructor();

  static final _gardenService = GardenService();
  static final _imageService = ImageService();
  static final _biodiversityService = BiodiversityService();
  static final _speciesService = SpeciesService();
  static final _takeHomeMessageService = TakeHomeMessageService();
  static final _mapMarkerService = MapMarkerService();
  static final _instance = ServiceProvider._privateConstructor();

  /// Instance of the ServiceProvider
  static final ServiceProvider instance = _instance;

  /// Reference to the GardenService
  final GardenService gardenService = _gardenService;

  /// Reference to the ImageService
  final ImageService imageService = _imageService;

  /// Reference to the BiodiversityService
  final BiodiversityService biodiversityService = _biodiversityService;

  /// Reference to the SpeciesService
  final SpeciesService speciesService = _speciesService;

  /// Reference to the TakeHomeMessageService
  final TakeHomeMessageService takeHomeMessageService = _takeHomeMessageService;

  /// Reference to the MapMarkerService
  final MapMarkerService mapMarkerService = _mapMarkerService;
}
