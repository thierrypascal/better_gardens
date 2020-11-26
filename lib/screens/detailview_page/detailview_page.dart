import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/information_list_page/information_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailViewPage extends StatefulWidget {
  final BiodiversityMeasure element;

  const DetailViewPage(this.element, {Key key}) : super(key: key);

  @override
  _DetailViewPageState createState() => _DetailViewPageState();
}

class _DetailViewPageState extends State<DetailViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventar")),
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
                    "Bauanleitung",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(widget.element.buildInstructions),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Gut für die folgenden Tiere:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.element.beneficialFor.length,
                      itemBuilder: (context, index) =>
                          Text(
                              "${widget.element.beneficialFor.keys.elementAt(
                                  index)} "),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}