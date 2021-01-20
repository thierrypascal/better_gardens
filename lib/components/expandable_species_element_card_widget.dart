import 'package:biodiversity/models/species.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_species.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A Card which shows an animal. If you tap on the card it extends.
/// And shows more information about the animal
class ExpandableSpeciesElementCard extends StatefulWidget {
  ///which species will be displayed
  final Species species;

  /// display a expandable card with the provided species
  ExpandableSpeciesElementCard(this.species);

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
              foregroundDecoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(widget.species.imageSource),
                      fit: BoxFit.fitWidth)),
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
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.species.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          "Mag: ${widget.species.supportedBy()}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Image(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    image: AssetImage(widget.species.imageSource),
                  ),
                ],
              ),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.species.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  if (widget.species != null)
                    FlatButton(
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
                        "Weitere infos",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  Consumer<User>(builder: (context, user, child) {
                    if (user == null) {
                      return const Text("");
                    }
                    return IconButton(
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
                    );
                  }),
                ],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 50),
                child: Text(
                  widget.species.short,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
