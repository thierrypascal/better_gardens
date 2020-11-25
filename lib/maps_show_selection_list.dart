import 'dart:developer' as logging;
import 'package:biodiversity/maps_select_from_selection_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:biodiversity/biodiversity_measure.dart';


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
            stream: Firestore.instance
                .collection('biodiversityMeasures')
                .where('type', isEqualTo: widget.elementType.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<BiodiversityMeasure> list = [];
              for (final DocumentSnapshot in snapshot.data.documents) {
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
