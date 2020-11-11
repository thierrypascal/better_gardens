import 'dart:ui';
import 'package:biodiversity/drawer.dart';
import 'package:biodiversity/garden.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final formControler = TextEditingController();

class MyGarden extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyGardenState();
  }
}

class _MyGardenState extends State<MyGarden> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mein Garten")),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('gardens').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Hurti es momentli..."));
          }

          return _buildBody(context, snapshot.data.documents);
        },
      ),
    );
  }
}

Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
  final garden = Garden.fromSnapshot(snapshot.first);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image(
        width: MediaQuery.of(context).size.width,
        height: 100,
        fit: BoxFit.fitWidth,
        image: const AssetImage('res/myGarden.jpg'),
      ),
      Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dein Garten enthält bereits:\n",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _ElementCounterCard("Anzahl Strukturelemente:",
                garden.numberOfStructureElements, const Icon(MdiIcons.wall)),
            _ElementCounterCard("Anzahl Pflanzen:", garden.numberOfPlants,
                const Icon(MdiIcons.nature)),
            _ElementCounterCard("Anzahl Methoden:", garden.numberOfMethods,
                const Icon(MdiIcons.meteor)),
            const Text(
              "Mein Garten durchsuchen...",
              style: TextStyle(backgroundColor: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _ElementCard("Steinwand", 5, const AssetImage('res/stonewall.jpg'),
                "Steinwand beschreibung"),
            Text(
                "Name: ${garden.name}\nStreet: ${garden.street}\nCity: ${garden.city}"),
            Form(
              child: TextFormField(
                initialValue: garden.name,
                onChanged: (value) => {garden.name = value},
              ),
            ),
            //TODO add working button
            MaterialButton(
              child: Text("SAVE"),
              onPressed: garden.saveGarden(),
            )
          ],
        ),
      ),
    ],
  );
}




class _ElementCounterCard extends StatelessWidget {
  final String text;
  final int data;
  final Icon icon;

  const _ElementCounterCard(this.text, this.data, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          icon,
          const VerticalDivider(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.grey),
                ),
                const Divider(
                  height: 0,
                  color: Colors.grey,
                ),
                Text(data.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ElementCard extends StatelessWidget {
  String name;
  int count;
  AssetImage image;
  String description;

  _ElementCard(this.name, this.count, this.image, this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(
          color: const Color.fromRGBO(200, 200, 200, 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$name",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Anzahl: $count"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bearbeiten",
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      const Text("Löschen",
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Image(
            image: AssetImage('res/stonewall.jpg'),
          ),
        ],
      ),
    );
  }
}
