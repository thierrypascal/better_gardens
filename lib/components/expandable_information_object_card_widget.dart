import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_information_object.dart';
import 'package:biodiversity/screens/information_list_page/add_element_to_garden_amount_page.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// an unspecific expandable card which displays an InformationObject
class ExpandableInformationObjectCard extends StatefulWidget {
  /// which element the cards shows
  final InformationObject object;

  /// if this flag is set, the buttons hinzufügen and merken will be removed
  final bool hideLikeAndAdd;

  /// additional Info to be displayed instead of hinzufügen and merken buttons.
  /// the Buttons will be automatically removed if this string is set
  final String additionalInfo;

  final ServiceProvider _serviceProvider;

  /// show a card to the provided InformationObject
  ExpandableInformationObjectCard(this.object,
      {hideLikeAndAdd = false,
      this.additionalInfo,
      ServiceProvider serviceProvider,
      Key key})
      : _serviceProvider = serviceProvider ??= ServiceProvider.instance,
        hideLikeAndAdd = hideLikeAndAdd || additionalInfo != null,
        super(key: key);

  @override
  _ExpandableInformationObjectCardState createState() =>
      _ExpandableInformationObjectCardState();
}

class _ExpandableInformationObjectCardState
    extends State<ExpandableInformationObjectCard> {
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
                child: widget._serviceProvider.imageService.getImage(
                  widget.object.name,
                  widget.object.type,
                )),
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
                      widget.object.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  if (!widget.hideLikeAndAdd)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddElementToGardenAmountPage(object: widget.object,)),
                            );
                          },
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
                                  .likeUnlikeElement(widget.object.name),
                          style: const ButtonStyle(
                              visualDensity: VisualDensity.compact),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: Provider.of<User>(context)
                                          .doesLikeElement(widget.object.name)
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
                  if (widget.additionalInfo != null)
                    Text(
                      widget.additionalInfo,
                      softWrap: true,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                    ),
                  const SizedBox(width: 4),
                  widget._serviceProvider.imageService.getImage(
                      widget.object.name, widget.object.type,
                      height: 60, width: 60, fit: BoxFit.cover),
                ],
              ),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(widget.object.name,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  if (!widget.hideLikeAndAdd)
                    Consumer<User>(builder: (context, user, child) {
                      if (user == null) {
                        return const Text('');
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddElementToGardenAmountPage(object: widget.object,)),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: user.doesLikeElement(widget.object.name)
                                  ? Colors.red
                                  : Colors.black38,
                            ),
                            onPressed: () {
                              setState(() {
                                user.likeUnlikeElement(widget.object.name);
                              });
                            },
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: const EdgeInsets.all(15),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.object.shortDescription,
                  softWrap: true,
                  textAlign: TextAlign.left,
                ),
              ),
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
                                    DetailViewPageInformationObject(
                                      widget.object,
                                    )),
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