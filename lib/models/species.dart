import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Container class for a species
class Species implements InformationObject {
  @override
  final String name;

  @override
  final String shortDescription;

  @override
  final String description;

  @override
  final String type;

  @override
  final String category;

  /// other species which
  final List<String> connectedTo;

  /// a list of objects which support this species
  final List<String> supportedBy;

  /// reference to the store location in the database
  final DocumentReference reference;

  /// reference to an imageSource of the species
  final String imageSource;

  final StorageProvider _storage;
  final ServiceProvider _service;

  /// creates a Species object from a Map
  Species.fromMap(Map<String, dynamic> map,
      {this.reference,
      StorageProvider storageProvider,
      ServiceProvider serviceProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        _service = serviceProvider ??= ServiceProvider.instance,
        category = map.containsKey('class') ? map['class'] as String : '',
        name = map.containsKey('name') ? map['name'] as String : '',
        shortDescription = map.containsKey('shortDescription')
            ? map['shortDescription'] as String
            : '',
        imageSource = map.containsKey('imageSource')
            ? map['imageSource'] as String
            : 'res/logo.png',
        description =
            map.containsKey('description') ? map['description'] as String : '',
        type = map.containsKey('type') ? map['type'] as String : '',
        connectedTo = map.containsKey('connectedTo')
            ? map['connectedTo'].cast<String>()
            : [],
        supportedBy = map.containsKey('supportedBy')
            ? map['supportedBy'].cast<String>()
            : [];

  /// creates a Species object from a database snapshot
  Species.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// returns a formatted string with the [BiodiversityMeasure]
  /// supporting the species
  String getSupportedBy() => _getCommaSeparatedString(supportedBy);

  /// returns a formatted string with other [Species]
  /// which go well together with this
  String getConnectedTo() => _getCommaSeparatedString(connectedTo);

  String _getCommaSeparatedString(Iterable<String> elements) {
    final string = StringBuffer();
    for (final s in elements) {
      string.write('$s, ');
    }
    final s = string.toString();
    if (s.length > 1) {
      return s.substring(0, s.length - 2);
    } else {
      return 'nichts';
    }
  }

  @override
  Map<String, Iterable<InformationObject>> get associationMap {
    return {
      'Unterstützt durch die folgenden Lebensräume:': _service
          .biodiversityService
          .getFullBiodiversityObjectList()
          .where((element) => supportedBy.contains(element.name)),
      'Verbunden mit:': _service.speciesService
          .getFullSpeciesObjectList()
          .where((element) => connectedTo.contains(element.name))
    };
  }
}
