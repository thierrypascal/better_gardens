import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/species_item_list_widget.dart';
import 'package:biodiversity/models/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class SpeciesListPage extends StatefulWidget {
  @override
  _SpeciesListPageState createState() => _SpeciesListPageState();
}

class _SpeciesListPageState extends State<SpeciesListPage> {
  TextEditingController editingController = TextEditingController();
  List _items;

  @override
  void initState() {
    super.initState();
    //TODO: load all types of species from service
    _items = [
      TagItem("Amphibien und Reptilien", true, 0),
      TagItem("Säugetiere", true, 1),
      TagItem("Vögel", true, 2),
      TagItem("Insekten und andere Kleintiere", true, 3),
      TagItem("Pflanzen und Pilze", true, 4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Arten")),
      drawer: MyDrawer(),
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
          Expanded(child: SpeciesItemListWidget(useSimpleCard: false)),
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
