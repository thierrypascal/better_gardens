import 'package:biodiversity/components/expandable_measure_element_card_widget.dart';
import 'package:biodiversity/components/simple_measure_element_card_widget.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/tag_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

/// displays a page with all biodiversity elements
class BiodiversityItemListWidget extends StatefulWidget {
  /// whether to use extendable cards or not
  final bool useSimpleCard;

  /// if [useSimpleCard] is set, the displayed cards will not be extendable
  BiodiversityItemListWidget({Key key, this.useSimpleCard}) : super(key: key);

  @override
  _BiodiversityItemListWidgetState createState() =>
      _BiodiversityItemListWidgetState();
}

class _BiodiversityItemListWidgetState
    extends State<BiodiversityItemListWidget> {
  List<TagItem> _tagItems = List<TagItem>();
  TextEditingController filterController = TextEditingController();
  List<BiodiversityMeasure> items = List<BiodiversityMeasure>();
  List<BiodiversityMeasure> filteredItems = List<BiodiversityMeasure>();

  @override
  void initState() {
    super.initState();
    items = Provider.of<BiodiversityService>(context, listen: false).getFullBiodiversityObjectList();
    filteredItems.addAll(items);
    createTagItems();
  }

  void createTagItems() {
    final categories =
    Provider.of<BiodiversityService>(context, listen: false).getAllClasses();
    for (String s in categories) {
      _tagItems.add(TagItem(s, false));
    }
  }

  void filterSearchResults(String query) {
    List<BiodiversityMeasure> tempList = List<BiodiversityMeasure>();
    tempList.addAll(items);
    if(query.isNotEmpty) {
      List<BiodiversityMeasure> tempListData = List<BiodiversityMeasure>();
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
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: filterController,
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
                    combine: ItemTagsCombine.withTextBefore,
                    onPressed: print,
                    //TODO: Implement sorting functionality
                    activeColor: Colors.grey,
                    borderRadius: BorderRadius.zero,
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
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst.where((a) => a.active == true).forEach((a) => print(a.title));
  }
}
