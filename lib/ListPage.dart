import 'package:flutter/material.dart';
import 'package:biodiversity/main.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      drawer: MyDrawer(),
      body: new DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: [
                Tab(text: 'ELEMENT',),
                Tab(text: 'PLANT',),
                Tab(text: 'METHOD',),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              SubList(elementType: 'Element',),
              SubList(elementType: 'Plant',),
              SubList(elementType: 'Method',)
            ],
          ),
        ),
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each listelement into expandable
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
                  (context, index) => ListTile(title: Text( widget.elementType +' #$index')),
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}