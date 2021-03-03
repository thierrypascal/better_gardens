import 'package:biodiversity/components/expandable_species_element_card_widget.dart';
import 'package:biodiversity/components/simple_species_element_card_widget.dart';
import 'package:biodiversity/models/species.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:biodiversity/models/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

class SpeciesItemListWidget extends StatefulWidget {
  final bool useSimpleCard;

  SpeciesItemListWidget({Key key, this.useSimpleCard}) : super(key: key);

  @override
  _SpeciesItemListWidgetState createState() => _SpeciesItemListWidgetState();
}

class _SpeciesItemListWidgetState extends State<SpeciesItemListWidget> {
  TextEditingController editingController = TextEditingController();
  List _items;

  @override
  void initState() {
    //TODO: load all types of species from service
    _items = [
      TagItem("Amphibien und Reptilien", true, 0),
      TagItem("Säugetiere", true, 1),
      TagItem("Vögel", true, 2),
      TagItem("Insekten und andere Kleintiere", true, 3),
      TagItem("Pflanzen und Pilze", true, 4),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    //filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Suchen",
                      hintText: "Suchen",
                      prefixIcon: Icon(Icons.search),
                      border: UnderlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0)))),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Tags(
                key: _tagStateKey,
                itemCount: _items.length,
                alignment: WrapAlignment.start,
                runSpacing: 6,
                itemBuilder: (index) {
                  final item = _items[index];

                  return ItemTags(
                    key: Key(index.toString()),
                    index: index,
                    title: item.title,
                    active: item.active,
                    customData: item.customData,
                    textStyle: TextStyle(
                      fontSize: 14,
                    ),
                    combine: ItemTagsCombine.withTextBefore,
                    onPressed: (item) => print(item),
                    //TODO: Implement sorting functionality
                    activeColor: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return _itemList(context, useSimpleCard: widget.useSimpleCard);
              },
            ),
          ),
        ],
      ),
    );
  }

  //TODO: create own file ItemList, together with biodiversity_item_list_widget.dart
  Widget _itemList(BuildContext context, {bool useSimpleCard = false}) {
    final List<Species> list =
    Provider.of<SpeciesService>(context).getFullSpeciesObjectList();

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
                ? SimpleSpeciesElementCard(element)
                : ExpandableSpeciesElementCard(element);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 5);
          },
        ),
      ),
    );
  }


  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst.where((a) => a.active == true).forEach((a) => print(a.title));
  }
}
