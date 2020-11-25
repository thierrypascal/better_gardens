import 'package:biodiversity/maps_select_from_selection_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ShowSelectionList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'ELEMENT',
              ),
              Tab(
                text: 'PLANT',
              ),
              Tab(
                text: 'METHOD',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SubList(
              elementType: 'Element',
            ),
            SubList(
              elementType: 'Plant',
            ),
            SubList(
              elementType: 'Method',
            )
          ],
        ),
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each list element into expandable
class SubList extends StatefulWidget {
  SubList({Key key, this.elementType}) : super(key: key);

  final String elementType;

  @override
  _SubListState createState() => _SubListState();
}

class _SubListState extends State<SubList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('biodiversityMeasures')
                .where('type', isEqualTo: widget.elementType.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<BiodiversityMeasure> list = [];
              for (final DocumentSnapshot in snapshot.data.docs) {
                list.add(BiodiversityMeasure.fromSnapshot(DocumentSnapshot));
              }
              if (list.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Leider keine Einträge vorhanden",
                          textScaleFactor: 2,
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.emoji_nature,
                          size: 80,
                        )
                      ],
                    ));
              }
              return ListView.separated(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final element = list.elementAt(index);
                  final beneficialFor = StringBuffer();
                  for (final String item in element.beneficialFor.keys) {
                    beneficialFor.write('$item ');
                  }
                  return SelectElementCard(
                      element.name,
                      beneficialFor.toString().trim(),
                      AssetImage(element.imageSource),
                      widget.elementType);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 5);
                },
              );
            }),
      ),
    );
  }
}

//Remove class BiodiversityMeasure and import biodiversity_measure.dart when merched branch of Gabriel TODO
class BiodiversityMeasure {
  final String name;
  final String description;
  final String buildInstructions;
  final String type;
  final Map<String, bool> beneficialFor;
  final Map<String, bool> badFor;
  final String imageSource;
  final DocumentReference reference;

  BiodiversityMeasure(this.name, this.description, this.buildInstructions,
      this.type, this.beneficialFor, this.reference, this.imageSource, this.badFor);

  BiodiversityMeasure.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : "",
        description =
        map.containsKey('description') ? map['description'] as String : "",
        buildInstructions = map.containsKey('buildInstructions')
            ? map['buildInstructions'] as String
            : "",
        type = map.containsKey('type') ? map['type'] as String : "",
        beneficialFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        badFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        imageSource =
        map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    beneficialFor.removeWhere((key, value) => !value);
    badFor.removeWhere((key, value) => value);
  }

  BiodiversityMeasure.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
