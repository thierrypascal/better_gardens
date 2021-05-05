import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/tags/flutter_tags.dart';
import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/information_list_page/add_element_to_garden_amount_page.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// Shows the details of a BiodiversityMeasure
class DetailViewPageInformationObject extends StatefulWidget {
  /// The BiodiversityMeasure element which will be displayed
  final InformationObject object;

  /// which page the navigator should go to if no page is on the stack below
  final PageRoute fallbackRoute;

  /// Shows the details of a BiodiversityMeasure
  const DetailViewPageInformationObject(this.object,
      {this.fallbackRoute, Key key})
      : super(key: key);

  @override
  _DetailViewPageInformationObjectState createState() =>
      _DetailViewPageInformationObjectState();
}

class _DetailViewPageInformationObjectState
    extends State<DetailViewPageInformationObject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Details: ${widget.object.name}',
        softWrap: true,
      )),
      drawer: MyDrawer(),
      body: Column(
        children: [
          ServiceProvider.instance.imageService
              .getImage(widget.object.name, widget.object.type, height: 150),
          TextButton(
            onPressed: () {
              Navigator.canPop(context)
                  ? Navigator.pop(context)
                  : Navigator.push(context, widget.fallbackRoute);
            },
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                const SizedBox(width: 5),
                const Text('Zurück zur Liste'),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                _headRow(),
                MarkdownBody(data: widget.object.description),
                const SizedBox(
                  height: 20,
                ),
                _showTags(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            widget.object.name,
            softWrap: true,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Consumer<User>(
          builder: (context, user, child) {
            return Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddElementToGardenAmountPage(
                                object: widget.object,
                              )),
                    );
                  },
                ),
                IconButton(
                  icon: user.doesLikeElement(widget.object.name)
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  color: user.doesLikeElement(widget.object.name)
                      ? Colors.red
                      : Colors.black38,
                  onPressed: () {
                    setState(() {
                      user.likeUnlikeElement(widget.object.name);
                    });
                  },
                ),
              ],
            );
          },
        )
      ],
    );
  }

  Widget _showTags() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.object.associationMap.length,
      itemBuilder: (context, category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.object.associationMap.keys.elementAt(category),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Tags(
              itemCount: widget.object.associationMap.values
                  .elementAt(category)
                  .length,
              spacing: 4,
              runSpacing: -2,
              itemBuilder: (index) {
                final element = widget.object.associationMap.values
                    .elementAt(category)
                    .elementAt(index);
                print(element);
                return ElevatedButton(
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailViewPageInformationObject(
                            element,
                            fallbackRoute: widget.fallbackRoute),
                      ),
                    );
                  },
                  child: Text(
                    element.name,
                  ),
                );
              },
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}
