import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/expandable_element_card_widget.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:flutter/material.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:provider/provider.dart';

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
          return ItemList(elementType: elementType);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(IconsBiodiversity.structure), label: "Struktur"),
          BottomNavigationBarItem(icon: Icon(IconsBiodiversity.plant), label: "Pflanzen"),
          BottomNavigationBarItem(icon: Icon(IconsBiodiversity.method), label: "Methoden"),
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

  const ItemList({Key key, this.elementType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BiodiversityMeasure> list =
        Provider.of<BiodiversityService>(context)
            .getBiodiversityObjectList(elementType);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            final element = list.elementAt(index);

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
            return ExpandableElementCard(
              element.name,
              element.beneficialFor(),
              AssetImage(element.imageSource),
              element.description,
              element: element,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5);
          },
        ),
      ),
    );
  }
}
