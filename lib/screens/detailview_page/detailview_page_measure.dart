import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_measures_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailViewPageMeasure extends StatefulWidget {
  final BiodiversityMeasure element;

  const DetailViewPageMeasure(this.element, {Key key}) : super(key: key);

  @override
  _DetailViewPageMeasureState createState() => _DetailViewPageMeasureState();
}

class _DetailViewPageMeasureState extends State<DetailViewPageMeasure> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [            
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InformationListPage()),
                            );
                    }),
                Text("Zurück zur Liste"),
              ],
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
                            return Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon:
                                      user.doesLikeElement(widget.element.name)
                                          ? const Icon(Icons.favorite)
                                          : const Icon(Icons.favorite_border),
                                  color:
                                      user.doesLikeElement(widget.element.name)
                                          ? Colors.red
                                          : Colors.black38,
                                  onPressed: () {
                                    setState(() {
                                      user.likeUnlikeElement(
                                          widget.element.name);
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        // IconButton(
                        //     icon: const Icon(Icons.close),
                        //     onPressed: () {
                        //       Navigator.canPop(context)
                        //           ? Navigator.pop(context)
                        //           : Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       InformationListPage()),
                        //             );
                        //     }),
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
                  Text(widget.element.goodTogetherWith.length.toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Gut für die folgenden Tiere:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(widget.element.beneficialFor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
