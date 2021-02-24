import 'package:biodiversity/components/biodiversity_item_list_widget.dart';
import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tags/flutter_tags.dart';

//TODO rename to habitatelements
class InformationListPage extends StatefulWidget {
  @override
  _InformationListPageState createState() => _InformationListPageState();
}

class _InformationListPageState extends State<InformationListPage> {
  List _items;

  @override
  void initState() {
    super.initState();
    //TODO: load all types of habitat elements from service
    _items = [
      TagItem("Mauern und Beläge", true, 0),
      TagItem("Lebensbereiche", true, 1),
      TagItem("Gehölze", true, 2),
      TagItem("Gebäude", true, 3),
      TagItem("Kleinstrukturen", true, 4),
      TagItem("Nisthilfen", true, 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lebensräume")),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.search, size: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Suchen'),
                    ),
                  ),
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
                itemBuilder: (index) {
                  final item = _items[index];

                  return ItemTags(
                    key: Key(index.toString()),
                    index: index,
                    title: item.title,
                    active: item.active,
                    customData: item.customData,
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                    combine: ItemTagsCombine.withTextBefore,
                    onPressed: (item) => print(item),   //TODO: Implement sorting functionality
                    activeColor: Colors.green,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: BiodiversityItemListWidget(
              useSimpleCard: false,
            ),
          )
        ],
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
