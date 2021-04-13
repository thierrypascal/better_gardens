import 'package:biodiversity/models/image_service.dart';
import 'package:biodiversity/models/take_home_message.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_take_home_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// A Card which shows a take home message. If you tap on the card it extends.
/// And shows more information about the message
class ExpandableTakeHomeMessageCard extends StatefulWidget {
  /// which message the cards shows
  final TakeHomeMessage takeHomeMessage;

  /// show a card to the provided element
  ExpandableTakeHomeMessageCard(this.takeHomeMessage, {Key key})
      : super(key: key);

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
                child: Provider.of<ImageService>(context, listen: false)
                    .getImage(widget.takeHomeMessage.title, 'takeHomeMessage')),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.takeHomeMessage.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(widget.takeHomeMessage.readTime,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Provider.of<ImageService>(context, listen: false).getImage(
                      widget.takeHomeMessage.title, 'takeHomeMessage',
                      width: 50, height: 50, fit: BoxFit.fill)
                ],
              ),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.takeHomeMessage.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  Text(widget.takeHomeMessage.readTime,
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 50),
                child:
                    MarkdownBody(data: widget.takeHomeMessage.shortDescription),
              ),
              if (widget.takeHomeMessage != null)
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
                                      DetailViewPageTakeHomeMessage(
                                          widget.takeHomeMessage)),
                            ).then((value) {
                              setState(() {});
                            });
                          }
                        },
                        child: const Text(
                          'Weiterlesen',
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
