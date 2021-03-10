import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/expandable_take_home_message_card_widget.dart';
import 'package:biodiversity/models/take_home_message.dart';
import 'package:flutter/material.dart';

class TakeHomeMessagePage extends StatefulWidget {
  TakeHomeMessagePage({Key key})
      : super(key: key);

  @override
  _TakeHomeMessagePageState createState() => _TakeHomeMessagePageState();
}

class _TakeHomeMessagePageState extends State<TakeHomeMessagePage> {
  List<TakeHomeMessage> items = List<TakeHomeMessage>();

  @override
  void initState() {
    super.initState();
  }

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
        child: items.isEmpty
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
          itemCount: items.length,
          itemBuilder: (context, index) {
            final element = items.elementAt(index);
            return ExpandableTakeHomeMessageCard(element);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 5);
          },
        ),
      ),
    );
  }


}
