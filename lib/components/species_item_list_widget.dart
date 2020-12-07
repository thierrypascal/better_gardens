import 'package:biodiversity/components/simple_species_element_card_widget.dart';
import 'package:biodiversity/models/species.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biodiversity/components/expandable_species_element_card_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SpeciesItemListWidget extends StatefulWidget {
  final bool useSimpleCard;

  const SpeciesItemListWidget({Key key, this.useSimpleCard}) : super(key: key);

  @override
  _SpeciesItemListWidgetState createState() => _SpeciesItemListWidgetState();
}

class _SpeciesItemListWidgetState extends State<SpeciesItemListWidget> {
  final _pageList = [
    "Amphibien",
    "Reptilien",
    "Säugetiere",
    "Vögel",
    "Krebstiere",
    "Insekten",
    "Spinnentiere",
    "Ringelwürmer",
    "Schnecken",
    "Tausendfüsser"
  ];
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
        itemBuilder: (BuildContext context, int index) {
          final String elementType = _pageList.elementAt(index);
          return ItemList(elementType, widget.useSimpleCard);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.green,
          height: 57,
          child: Center(
            child: SizedBox.expand(
              child: FlatButton(
                onPressed: () => displayBottomSheet(context),
                child: Text(_pageList[_currentPage], style: const TextStyle(color: Colors.white), textScaleFactor: 1.2,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void displayBottomSheet(BuildContext context){
    showMaterialModalBottomSheet(
      expand: true,
      context: context,
      builder: (ctx){
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Container(
            child: ListView.builder(
              itemCount: _pageList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_pageList[index], style: const TextStyle(color: Colors.white),),
                  onTap: () {
                    _onTap(index);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      }
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

//TODO: create own file ItemList, together with biodiversity_item_list_widget.dart
class ItemList extends StatelessWidget {
  final String elementType;
  final bool _useSimpleCard;

  const ItemList(this.elementType, this._useSimpleCard, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Species> list =
        Provider.of<SpeciesService>(context).getSpeciesObjectList(elementType);
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
                itemBuilder: (BuildContext context, int index) {
                  final element = list.elementAt(index);
                  return _useSimpleCard
                      ? SimpleSpeciesElementCard(element)
                      : ExpandableSpeciesElementCard(element);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 5);
                },
              ),
      ),
    );
  }
}
