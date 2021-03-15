import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_measure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// A Card which shows a habitat element. If you tap on the card it extends.
/// And shows more information about the element
class ExpandableMeasureElementCard extends StatefulWidget {
  /// which element the cards shows
  final BiodiversityMeasure element;

  /// show a card to the provided element
  ExpandableMeasureElementCard(this.element, {Key key}) : super(key: key);

  @override
  _ExpandableMeasureElementCardState createState() =>
      _ExpandableMeasureElementCardState();
}

class _ExpandableMeasureElementCardState
    extends State<ExpandableMeasureElementCard> {
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
                      image: AssetImage(widget.element.imageSource),
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
                  Expanded(
                    child: Text(
                      widget.element.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlatButton(
                        onPressed: () {},
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
                      FlatButton(
                        onPressed: () =>
                            Provider.of<User>(context, listen: false)
                                .likeUnlikeElement(widget.element.name),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.favorite,
                                color: Provider.of<User>(context)
                                        .doesLikeElement(widget.element.name)
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
                  Image(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    image: AssetImage(widget.element.imageSource),
                  ),
                ],
              ),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.element.name,
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
                            color: user.doesLikeElement(widget.element.name)
                                ? Colors.red
                                : Colors.black38,
                          ),
                          onPressed: () {
                            setState(() {
                              user.likeUnlikeElement(widget.element.name);
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
                child: MarkdownBody(data: widget.element.description),
              ),
              if (widget.element != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: FlatButton(
                        onPressed: () {
                          if (_expanded) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailViewPageMeasure(widget.element)),
                            ).then((value) {
                              setState(() {});
                            });
                          }
                        },
                        child: const Text(
                          "Weitere infos",
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
