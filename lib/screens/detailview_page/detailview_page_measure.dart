import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/tags/flutter_tags.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/image_service.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_species.dart';
import 'package:biodiversity/screens/information_list_page/habitat_elements_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// Shows the details of a BiodiversityMeasure
class DetailViewPageMeasure extends StatefulWidget {
  /// The BiodiversityMeasure element which will be displayed
  final BiodiversityMeasure element;

  /// Shows the details of a BiodiversityMeasure
  const DetailViewPageMeasure(this.element, {Key key}) : super(key: key);

  @override
  _DetailViewPageMeasureState createState() => _DetailViewPageMeasureState();
}

class _DetailViewPageMeasureState extends State<DetailViewPageMeasure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details: ${widget.element.name}')),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Provider.of<ImageService>(context).getImage(
              widget.element.name, widget.element.type,
              height: 150, width: MediaQuery.of(context).size.width),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
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
                      'Gut für die folgenden Tiere:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Tags(
                        itemCount: widget.element.beneficialFor.length,
                        spacing: 4,
                        runSpacing: -2,
                        itemBuilder: (index) {
                          return ElevatedButton(
                              child: Text(widget.element.beneficialFor[index]),
                              style: const ButtonStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                final element = Provider.of<SpeciesService>(
                                        context,
                                        listen: false)
                                    .getSpeciesByName(
                                        widget.element.beneficialFor[index]);
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
