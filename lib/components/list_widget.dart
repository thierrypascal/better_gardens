import 'package:biodiversity/components/expandable_measure_element_card_widget.dart';
import 'package:biodiversity/components/expandable_species_element_card_widget.dart';
import 'package:biodiversity/components/simple_measure_element_card_widget.dart';
import 'package:biodiversity/components/simple_species_element_card_widget.dart';

//import 'package:flutter_tags/flutter_tags.dart';
import 'package:biodiversity/components/tags/flutter_tags.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:biodiversity/models/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListWidget extends StatefulWidget {
  final bool useSimpleCard;
  final bool isSpeciesList;

  ListWidget({Key key, this.useSimpleCard, this.isSpeciesList})
      : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final List<TagItem> _tagItems = <TagItem>[];
  TextEditingController editingController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  List categories = [];
  List items = [];
  List categorisedItems = [];
  List filteredItems = [];

  @override
  void initState() {
    super.initState();
    widget.isSpeciesList
        ? items = Provider.of<SpeciesService>(context, listen: false)
            .getFullSpeciesObjectList()
        : items = Provider.of<BiodiversityService>(context, listen: false)
            .getFullBiodiversityObjectList();
    categorisedItems.addAll(items);
    filteredItems.addAll(categorisedItems);
    createTagItems();
  }

  void createTagItems() {
    widget.isSpeciesList
        ? categories =
            Provider.of<SpeciesService>(context, listen: false).getAllClasses()
        : categories = Provider.of<BiodiversityService>(context, listen: false)
            .getAllClasses();

    for (String s in categories) {
      _tagItems.add(TagItem(s, true));
    }
  }

  void filterClassResults() {
    var tempList = [];
    tempList.addAll(items);
    List tempActiveItemList = _tagStateKey.currentState.getAllActiveItems;

    if (widget.isSpeciesList) {
      if (tempActiveItemList != null && tempActiveItemList.isNotEmpty) {
        var tempListData = [];
        for (var item in tempList) {
          for (var activeTag in tempActiveItemList) {
            if (item.speciesClass.contains(activeTag)) {
              tempListData.add(item);
            }
          }
        }
        setState(() {
          categorisedItems.clear();
          categorisedItems.addAll(tempListData);
        });
      } else {
        setState(() {
          categorisedItems.clear();
          categorisedItems.addAll(items);
        });
      }
    } else {
      if (tempActiveItemList != null && tempActiveItemList.isNotEmpty) {
        var tempListData = [];
        for (var item in tempList) {
          for (var activeTag in tempActiveItemList) {
            if (item.type.contains(activeTag)) {
              tempListData.add(item);
            }
          }
        }
        setState(() {
          categorisedItems.clear();
          categorisedItems.addAll(tempListData);
        });
      } else {
        setState(() {
          categorisedItems.clear();
          categorisedItems.addAll(items);
        });
      }
    }
    filterSearchResults('');
  }

  void filterSearchResults(String query) {
    var tempList = [];
    tempList.addAll(categorisedItems);
    if (query.isNotEmpty) {
      var tempListData = [];
      for (var item in tempList) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          tempListData.add(item);
        }
      }
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(tempListData);
      });
      return;
    } else {
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(categorisedItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: 'Suchen',
                      hintText: 'Suchen',
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Container(
                      height: 24,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlatButton(
                            child: Text('Alle selektieren'),
                            onPressed: () {
                              _tagStateKey.currentState.setAllItemsActive();
                              filterClassResults();
                            },
                          ),
                          FlatButton(
                            child: Text('Selektion aufheben'),
                            onPressed: () {
                              _tagStateKey.currentState.setAllItemsInactive();
                              filterClassResults();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tags(
                    key: _tagStateKey,
                    itemCount: _tagItems.length,
                    alignment: WrapAlignment.start,
                    runSpacing: 6,
                    horizontalScroll: false,
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
                        textActiveColor: Colors.black,
                        elevation: 3,
                        textOverflow: TextOverflow.fade,
                        combine: ItemTagsCombine.withTextBefore,
                        onPressed: (item) {
                          filterClassResults();
                        },
                        activeColor: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      );
                    },
                  ),
                ],
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

  //TODO: create own file ItemList, merged with biodiversity_item_list_widget
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
                      'Leider keine Einträge vorhanden',
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
                  return widget.isSpeciesList
                      ? useSimpleCard
                          ? SimpleSpeciesElementCard(element)
                          : ExpandableSpeciesElementCard(element)
                      : useSimpleCard
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

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  _getAllItem() {
    var lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null) {
      lst
          .where((a) => a.active == true)
          .forEach((a) => print('${a.title}, ${a.active}'));
    }
  }
}
