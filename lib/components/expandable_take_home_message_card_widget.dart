import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_measure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A Card which shows a take home message. If you tap on the card it extends.
/// And shows more information about the message
class ExpandableTakeHomeMessageCard extends StatefulWidget {
  /// which message the cards shows
  final BiodiversityMeasure element;

  /// show a card to the provided element
  ExpandableTakeHomeMessageCard(this.element, {Key key}) : super(key: key);

  @override
  _ExpandableTakeHomeMessageCardState createState() =>
      _ExpandableTakeHomeMessageCardState();
}

class _ExpandableTakeHomeMessageCardState
    extends State<ExpandableTakeHomeMessageCard> {
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
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.element.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          'Gut für: ${widget.element.beneficialFor}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
                  if (widget.element != null)
                    FlatButton(
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
                        'Weitere infos',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  Consumer<User>(builder: (context, user, child) {
                    if (user == null) {
                      return const Text('');
                    }
                    return IconButton(
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
                    );
                  }),
                ],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 50),
                child: Text(
                  widget.element.description,
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
