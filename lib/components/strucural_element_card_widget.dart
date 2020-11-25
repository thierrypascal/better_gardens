import 'file:///C:/Users/gabri/ip34/mobile-front-end/lib/models/biodiversity_measure.dart';
import 'file:///C:/Users/gabri/ip34/mobile-front-end/lib/screens/detailview_page/detailview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StructuralElementCard extends StatefulWidget {
  final String name;
  final String beneficialFor;
  final AssetImage image;
  final String description;
  final BiodiversityMeasure element;

  const StructuralElementCard(
      this.name, this.beneficialFor, this.image, this.description,
      {this.element});

  @override
  _StructuralElementCardState createState() => _StructuralElementCardState();
}

class _StructuralElementCardState extends State<StructuralElementCard> {
  bool expanded = false;

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
              height: expanded ? 100 : 0,
              foregroundDecoration: BoxDecoration(
                  image: DecorationImage(
                      image: widget.image, fit: BoxFit.fitWidth)),
            ),
          ),
          ExpansionTile(
            onExpansionChanged: (value) {
              setState(() {
                expanded = value;
              });
            },
            title: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: expanded
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailViewPage(widget.element)),
                        );
                      },
                      child: const Text(
                        "Weitere infos",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  //TODO implement like functionality
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.white24,
                    ),
                    onPressed: () {},
                  )
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
