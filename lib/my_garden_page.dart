import 'dart:ui';

import 'package:biodiversity/drawer.dart';
import 'package:biodiversity/garden.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Mein Garten")),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('gardens').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return _buildBody(context, snapshot.data.documents);
        },
      ),
    );
  }
}

Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
  final garden = Garden.fromSnapshot(snapshot.first);
  final TextEditingController _textController =
      TextEditingController(text: garden.name);

  void _onSaveGarden() {
    if (garden.name != _textController.text.trim()) {
      garden.name = _textController.text.trim();
      garden.saveGarden();
    }
  }

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Image(
              width: MediaQuery.of(context).size.width,
              height: 100,
              fit: BoxFit.fitWidth,
              image: const AssetImage('res/myGarden.jpg'),
              semanticLabel: garden.name,
            ),
            Center(
              child: Text(
                garden.name,
                textAlign: TextAlign.center,
                softWrap: true,
                textScaleFactor: 2,
                style:
                    const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8)),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: -10)),
                      controller: _textController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _onSaveGarden,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: garden.ownedObjects.length,
                itemBuilder: (BuildContext context, int index) {
                  final String name =
                      garden.ownedObjects.entries.elementAt(index).key;
                  final int count =
                      garden.ownedObjects.entries.elementAt(index).value;

                  return _ElementCard(
                      name,
                      count,
                      garden,
                      //TODO implement a more save to load the images
                      AssetImage("res/$name.jpg"),
                      "Beschreibung von $name");
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 3);
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ElementCounterCard extends StatelessWidget {
  final String text;
  final int data;
  final Icon icon;

  const _ElementCounterCard(this.text, this.data, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _ElementCard extends StatelessWidget {
  final String name;
  final int count;
  final AssetImage image;
  final String description;
  final Garden garden;

  const _ElementCard(
      this.name, this.count, this.garden, this.image, this.description);

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
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Anzahl: $count"),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          garden.removeFromOwnedObjects(name);
                          garden.saveGarden();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Image(
            width: 90,
            height: 60,
            fit: BoxFit.cover,
            image: image,
          ),
        ],
      ),
    );
  }
}
