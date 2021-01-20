import 'package:biodiversity/components/expandable_measure_element_card_widget.dart';
import 'package:biodiversity/components/simple_measure_element_card_widget.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// displays a page with three categories of biodiversity elements
class BiodiversityItemListWidget extends StatefulWidget {
  /// whether to use extendable cards or not
  final bool useSimpleCard;

  /// Page with three categories ["Element", "Plant", "Method"]
  /// if [useSimpleCard] is set, the displayed cards will not be extendable
  BiodiversityItemListWidget({Key key, this.useSimpleCard}) : super(key: key);

  @override
  _BiodiversityItemListWidgetState createState() =>
      _BiodiversityItemListWidgetState();
}

class _BiodiversityItemListWidgetState
    extends State<BiodiversityItemListWidget> {
  final _pageList = ["Element", "Plant", "Method"];
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _pageList.length,
        itemBuilder: (context, index) {
          final elementType = _pageList.elementAt(index);
          return _itemList(context, elementType,
              useSimpleCard: widget.useSimpleCard);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(IconsBiodiversity.structure), label: "Struktur"),
          BottomNavigationBarItem(
              icon: Icon(IconsBiodiversity.plant), label: "Pflanzen"),
          BottomNavigationBarItem(
              icon: Icon(IconsBiodiversity.method), label: "Methoden"),
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

  Widget _itemList(BuildContext context, String elementType,
      {bool useSimpleCard = false}) {
    final list = Provider.of<BiodiversityService>(context)
        .getBiodiversityObjectList(elementType);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: list.isEmpty
            ? Center(
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
              )
            : ListView.separated(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final element = list.elementAt(index);
                  return useSimpleCard
                      ? SimpleMeasureElementCard(element)
                      : ExpandableMeasureElementCard(element);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5);
                },
              ),
      ),
    );
  }
}
