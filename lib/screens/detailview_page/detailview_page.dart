import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/screens/information_list_page/information_list_page.dart';
import 'package:flutter/material.dart';

class DetailViewPage extends StatelessWidget {
  final BiodiversityMeasure element;

  const DetailViewPage(this.element, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventar")),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage(element.imageSource),
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
                        element.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row(children: [
                        //TODO implement like functionality
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
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
                  Text(element.description),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Bauanleitung",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(element.buildInstructions),
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
                      itemCount: element.beneficialFor.length,
                      itemBuilder: (context, index) => Text(
                          "${element.beneficialFor.keys.elementAt(index)} "),
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
