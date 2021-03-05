import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_measures_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      body: Column(
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
              FlatButton(
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back),
                      SizedBox(width: 5),
                      Text("Zurück zur Liste"),
                    ],
                  ),
                  onPressed: () {
                    Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InformationListPage()),
                          );
                  }),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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
                        Consumer<User>(
                          builder: (context, user, child) {
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
                        )
                      ],
                    ),
                    MarkdownBody(data: widget.element.description),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Gut für die folgenden Tiere:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(widget.element.beneficialFor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
