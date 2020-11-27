
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpandableElementCard extends StatefulWidget {
  final String name;
  final String beneficialFor;
  final AssetImage image;
  final String description;
  final BiodiversityMeasure element;

  const ExpandableElementCard(
      this.name, this.beneficialFor, this.image, this.description,
      {this.element});

  @override
  _ExpandableElementCardState createState() => _ExpandableElementCardState();
}

class _ExpandableElementCardState extends State<ExpandableElementCard> {
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
                      image: widget.image, fit: BoxFit.fitWidth)),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Gut für: ${widget.beneficialFor}"),
                    ],
                  ),
                  Image(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    image: widget.image,
                  ),
                ],
              ),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  if (widget.element != null)
                    FlatButton(
                      onPressed: () {
                        if (_expanded) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailViewPage(widget.element)),
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
                        color: user.doesLikeElement(widget.name)
                            ? Colors.red
                            : Colors.black38,
                      ),
                      onPressed: () {
                        setState(() {
                          user.likeUnlikeElement(widget.name);
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
                  widget.description,
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
