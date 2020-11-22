import 'package:biodiversity/drawer.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {

  //TEST
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: const Text('List'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'ELEMENT',
              ),
              Tab(
                text: 'PLANT',
              ),
              Tab(
                text: 'METHOD',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SubList(
              elementType: 'Element',
            ),
            SubList(
              elementType: 'Plant',
            ),
            SubList(
              elementType: 'Method',
            )
          ],
        ),
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each list element into expandable
class SubList extends StatefulWidget {
  SubList({Key key, this.elementType}) : super(key: key);

  final String elementType;

  @override
  _SubListState createState() => _SubListState();
}

class _SubListState extends State<SubList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  ListTile(title: Text("${widget.elementType}: $index")),
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}
