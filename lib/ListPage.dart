import 'package:flutter/material.dart';
import 'package:biodiversity/Drawer.dart';

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
        title: Text('Liste'),
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
                Tab(text: 'PFLANZE',),
                Tab(text: 'METHODE',),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ElementList(),
              PlantList(),
              MethodList(),
            ],
          ),
        ),
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each listelement into expandable
class ElementList extends StatelessWidget {
  ElementList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
                  (context, index) => ListTile(title: Text('Element #$index')),
              // Builds 200 ListTiles
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each listelement into expandable
class PlantList extends StatelessWidget {
  PlantList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Pflanze #$index')),
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each listelement into expandable
class MethodList extends StatelessWidget {
  MethodList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Methode #$index')),
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}
