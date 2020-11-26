import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/strucural_element_card_widget.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InformationListPage extends StatefulWidget {
  @override
  _InformationListPageState createState() => _InformationListPageState();
}

class _InformationListPageState extends State<InformationListPage> {
  final _pageList = ["Element", "Plant", "Method"];
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventar")),
      drawer: MyDrawer(),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _pageList.length,
        itemBuilder: (BuildContext context, int index) {
          final String elementType = _pageList.elementAt(index);
          return ItemList(
            elementType: elementType,
            data: FirebaseFirestore.instance
                .collection('biodiversityMeasures')
                .where('type', isEqualTo: elementType.toLowerCase())
                .snapshots(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.nature), label: "Struktur"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Pflanzen"),
          BottomNavigationBarItem(icon: Icon(Icons.save), label: "Methoden"),
        ],
        onTap: _onTap,
        currentIndex: _currentPage,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).disabledColor,
      ),
    );
  }

  void _onTap(int index) {
    _controller.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    setState(() {
      _currentPage = index;
    });
  }
}

class ItemList extends StatelessWidget {
  final String elementType;
  final Stream<QuerySnapshot> data;

  const ItemList({Key key, this.elementType, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: data,
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
                  ),
                );
              }
              return ListView.separated(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final element = list.elementAt(index);
                  final beneficialFor = StringBuffer();
                  for (final String item in element.beneficialFor.keys) {
                    beneficialFor.write('$item ');
                  }
                  return StructuralElementCard(
                    element.name,
                    beneficialFor.toString().trim(),
                    AssetImage(element.imageSource),
                    element.description,
                    element: element,
                  );
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