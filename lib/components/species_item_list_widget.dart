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
  List<TagItem> _tagItems = List<TagItem>();
  TextEditingController editingController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  List<Species> items = List<Species>();
  List<Species> filteredItems = List<Species>();

  @override
  void initState() {
    super.initState();
    items = Provider.of<SpeciesService>(context, listen: false).getFullSpeciesObjectList();
    filteredItems.addAll(items);
    createTagItems();
  }

  void createTagItems(){
    final categories = Provider.of<SpeciesService>(context, listen: false).getAllClasses();
    for (String s in categories){
      _tagItems.add(TagItem(s, true));
    }
  }

  void filterSearchResults(String query) {
    List<Species> tempList = List<Species>();
    tempList.addAll(items);
    if(query.isNotEmpty) {
      List<Species> tempListData = List<Species>();
      tempList.forEach((item) {
        if(item.name.toLowerCase().contains(query.toLowerCase())) {
          tempListData.add(item);
        }
      });
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(tempListData);
      });
      return;
    } else {
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(items);
      });
    }
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
                    filterSearchResults(value);
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
                itemCount: _tagItems.length,
                alignment: WrapAlignment.start,
                runSpacing: 6,
                horizontalScroll: true,
                heightHorizontalScroll: 40,
                itemBuilder: (index) {
                  final item = _tagItems[index];

                  return ItemTags(
                    key: Key(index.toString()),
                    index: index,
                    title: item.title,
                    active: item.active,
                    textStyle: TextStyle(
                      fontSize: 14,
                    ),
                    textOverflow: TextOverflow.fade,
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filteredItems.isEmpty
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
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final element = filteredItems.elementAt(index);
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
