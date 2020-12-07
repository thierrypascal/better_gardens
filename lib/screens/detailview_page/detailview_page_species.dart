import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/species.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_measures_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailViewPageSpecies extends StatefulWidget {
  final Species element;

  const DetailViewPageSpecies(this.element, {Key key}) : super(key: key);

  @override
  _DetailViewPageSpeciesState createState() => _DetailViewPageSpeciesState();
}

class _DetailViewPageSpeciesState extends State<DetailViewPageSpecies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details: ${widget.element.name}")),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage(widget.element.imageSource),
              fit: BoxFit.fitWidth,
              height: 150,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.element.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row(children: [
                        Consumer<User>(
                          builder: (BuildContext context, user, Widget child) {
                            if (user == null) {
                              return const Text("");
                            }
                            return IconButton(
                              icon: user.doesLikeElement(widget.element.name)
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_border),
                              color: user.doesLikeElement(widget.element.name)
                                  ? Colors.red
                                  : Colors.black38,
                              onPressed: () {
                                setState(() {
                                  user.likeUnlikeElement(widget.element.name);
                                });
                              },
                            );
                          },
                        ),
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InformationListPage()),
                                    );
                            }),
                      ])
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.element.description),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Tips",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(widget.element.tips),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Links",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(widget.element.links),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Wird durch folgende Elemente unterstützt:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(widget.element.supportedBy()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}