import 'package:biodiversity/components/drawer.dart';
import 'package:flutter/material.dart';

class TakeHomeMessagePage extends StatelessWidget {
  TakeHomeMessagePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Take-Home Messages")),
        drawer: MyDrawer(),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _itemList(context);
            },
        ),
      ),
    );
  }

  Widget _itemList(BuildContext context) {
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
                Icons.message,
                size: 80,
              )
            ],
          ),
        )
            : ListView.separated(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final element = filteredItems.elementAt(index);
            return ExpandableMeasureElementCard(element);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 5);
          },
        ),
      ),
    );
  }


}
