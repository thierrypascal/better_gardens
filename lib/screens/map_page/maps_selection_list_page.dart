import 'package:biodiversity/components/simple_element_card_widget.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Element auswählen'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'STRUKTUR'),
              Tab(text: 'PLANT'),
              Tab(text: 'METHOD'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            //Important: if elementType is changed, MapsPage.icons keys need to be changed accordingly
            SubList(elementType: 'Element'),
            SubList(elementType: 'Plant'),
            SubList(elementType: 'Method')
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
                  return SimpleElementCard(list.elementAt(index));
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
