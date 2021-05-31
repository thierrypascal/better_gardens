import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/information_object_list_widget.dart';
import 'package:biodiversity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of all BiodiversityElements
class FavoredListPage extends StatefulWidget {
  /// Displays a list of all BiodiversityElements
  FavoredListPage({Key key}) : super(key: key);

  @override
  _FavoredListPageState createState() => _FavoredListPageState();
}

class _FavoredListPageState extends State<FavoredListPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merkliste')),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          //TODO: change Icons
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Lebensräume'),
          BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Arten'),
        ],
        onTap: _onTappedBar,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: <Widget>[
          _FavoredHabitatElements(),
          _FavoredSpecies(),
        ],
      ),
    );
  }

  Widget _FavoredHabitatElements() {
    return InformationObjectListWidget(
      objects: Provider.of<User>(context).favoredHabitatObjects,
    );
  }

  Widget _FavoredSpecies() {
    return InformationObjectListWidget(
      objects: Provider.of<User>(context).favoredSpeciesObjects,
      isSpecies: true,
    );
  }
}
