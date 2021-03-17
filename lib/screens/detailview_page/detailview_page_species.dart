import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/tags/flutter_tags.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/species.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_measure.dart';
import 'package:biodiversity/screens/information_list_page/habitat_elements_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// Page which shows the details of a Species
class DetailViewPageSpecies extends StatefulWidget {
  /// Which Species will be displayed
  final Species element;

  /// Page which shows the details of a Species
  const DetailViewPageSpecies(this.element, {Key key}) : super(key: key);

  @override
  _DetailViewPageSpeciesState createState() => _DetailViewPageSpeciesState();
}

class _DetailViewPageSpeciesState extends State<DetailViewPageSpecies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details: ${widget.element.name}')),
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
                      const SizedBox(width: 5),
                      const Text('Zurück zur Liste'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HabitatElementListPage()),
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
                                  icon: const Icon(
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
                      'Unterstützt durch die folgenden Lebensräume:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      softWrap: true,
                    ),
                    Tags(
                        itemCount: widget.element.supportedBy.length,
                        spacing: 4,
                        runSpacing: -2,
                        itemBuilder: (index) {
                          return ElevatedButton(
                              child: Text(widget.element.supportedBy[index]),
                              style: const ButtonStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                final element =
                                    Provider.of<BiodiversityService>(context,
                                            listen: false)
                                        .getBiodiversityMeasureByName(
                                            widget.element.supportedBy[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailViewPageMeasure(element)));
                              });
                        }),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'Verbunden mit:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        softWrap: true,
                      ),
                    ),
                    Tags(
                        itemCount: widget.element.connectedTo.length,
                        spacing: 4,
                        runSpacing: -2,
                        itemBuilder: (index) {
                          return ElevatedButton(
                              child: Text(widget.element.connectedTo[index]),
                              style: const ButtonStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                final element = Provider.of<SpeciesService>(
                                        context,
                                        listen: false)
                                    .getSpeciesByName(
                                        widget.element.connectedTo[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailViewPageSpecies(element)));
                              });
                        }),
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
