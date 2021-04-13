import 'package:biodiversity/models/image_service.dart';
import 'package:biodiversity/models/species.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_species.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// A Card which shows an animal. If you tap on the card it extends.
/// And shows more information about the animal
class ExpandableSpeciesElementCard extends StatefulWidget {
  ///which species will be displayed
  final Species species;

  /// display a expandable card with the provided species
  ExpandableSpeciesElementCard(this.species, {Key key}) : super(key: key);

  @override
  _ExpandableSpeciesElementCardState createState() =>
      _ExpandableSpeciesElementCardState();
}

class _ExpandableSpeciesElementCardState
    extends State<ExpandableSpeciesElementCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: const Color.fromRGBO(200, 200, 200, 1),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(4)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _expanded ? 100 : 0,
              child: Provider.of<ImageService>(context, listen: false)
                  .getImage(widget.species.name, widget.species.type),
            ),
          ),
          ExpansionTile(
            onExpansionChanged: (value) {
              setState(() {
                _expanded = value;
              });
            },
            title: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.species.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                            visualDensity: VisualDensity.compact),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                            const Text('hinzufügen'),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Provider.of<User>(context, listen: false)
                                .likeUnlikeElement(widget.species.name),
                        style: const ButtonStyle(
                            visualDensity: VisualDensity.compact),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.favorite,
                                color: Provider.of<User>(context)
                                        .doesLikeElement(widget.species.name)
                                    ? Colors.red
                                    : Colors.black,
                                size: 20,
                              ),
                            ),
                            const Text('merken'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Provider.of<ImageService>(context).getImage(
                      widget.species.name, widget.species.type,
                      height: 60, width: 60, fit: BoxFit.cover),
                ],
              ),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.species.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Consumer<User>(builder: (context, user, child) {
                    if (user == null) {
                      return const Text('');
                    }
                    return Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: user.doesLikeElement(widget.species.name)
                                ? Colors.red
                                : Colors.black38,
                          ),
                          onPressed: () {
                            setState(() {
                              user.likeUnlikeElement(widget.species.name);
                            });
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 50),
                child: MarkdownBody(data: widget.species.description),
              ),
              if (widget.species != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextButton(
                        onPressed: () {
                          if (_expanded) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailViewPageSpecies(widget.species)),
                            ).then((value) {
                              setState(() {});
                            });
                          }
                        },
                        child: const Text(
                          'Weitere infos',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
