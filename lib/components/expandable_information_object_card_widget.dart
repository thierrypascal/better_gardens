import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/detailview_page/detailview_page_information_object.dart';
import 'package:biodiversity/screens/information_list_page/add_element_to_garden_amount_page.dart';
import 'package:biodiversity/screens/information_list_page/delete_element_garden_page.dart';
import 'package:biodiversity/screens/information_list_page/edit_element_to_garden_page.dart';
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

  /// if this flag is set, the buttons bearbeiten and löschen will be removed
  final bool showDeleteAndEdit;

  /// if this flag is set, the card is used for species and hinzufügen and merken will be changed to Aktivitätsradius and merken
  final bool isSpecies;

  /// additional Info to be displayed instead of hinzufügen and merken buttons.
  /// the Buttons will be automatically removed if this string is set
  final String additionalInfo;

  final ServiceProvider _serviceProvider;

  /// show a card to the provided InformationObject
  ExpandableInformationObjectCard(this.object,
      {hideLikeAndAdd = false,
      this.showDeleteAndEdit = false,
      this.isSpecies = false,
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

  //TODO: check if user logged in
  @override
  Widget build(BuildContext context) {
    final garden = Provider.of<Garden>(context, listen: false);
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.object.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          softWrap: true,
                        ),
                        if (widget.showDeleteAndEdit)
                          Text(garden.ownedObjects[widget.object.name]
                                  .toString() +
                              ' Anzahl'),
                      ],
                    ),
                  ),
                  if (widget.showDeleteAndEdit)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteElementGardenPage(
                                        object: widget.object,
                                      )),
                            );
                          },
                          style: const ButtonStyle(
                              visualDensity: VisualDensity.compact),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                              const Text('löschen'),
                            ],
                          ),
                        ),
                        TextButton(
                          //EditElementPage
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditElementPage(
                                        object: widget.object,
                                      )),
                            ),
                          },
                          style: const ButtonStyle(
                              visualDensity: VisualDensity.compact),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                              ),
                              const Text('bearbeiten'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (!widget.hideLikeAndAdd)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.isSpecies)
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddElementToGardenAmountPage(
                                          object: widget.object,
                                        )),
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
                        // : TextButton(
                        //     onPressed: null,
                        //     style: const ButtonStyle(
                        //         visualDensity: VisualDensity.compact),
                        //     child: Row(
                        //       children: [
                        //         const Padding(
                        //           padding: EdgeInsets.only(right: 8.0),
                        //           child: Icon(
                        //             Icons.add_circle_outline_outlined,
                        //             size: 20,
                        //           ),
                        //         ),
                        //         const Text('aktivitätsradius'),
                        //       ],
                        //     ),
                        //   ),
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
                          if (!widget.isSpecies)
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddElementToGardenAmountPage(
                                            object: widget.object,
                                          )),
                                );
                              },
                            ),
                          // : const IconButton(
                          //     icon: Icon(
                          //       Icons.add_circle_outline_outlined,
                          //     ),
                          //     onPressed: null,
                          //   ),
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
                  if (widget.showDeleteAndEdit)
                    Consumer<User>(builder: (context, user, child) {
                      if (user == null) {
                        return const Text('');
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeleteElementGardenPage(
                                          object: widget.object,
                                        )),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditElementPage(
                                          object: widget.object,
                                        )),
                              ),
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
                                      hideLikeAndAdd: widget.hideLikeAndAdd,
                                      showDeleteAndEdit:
                                          widget.showDeleteAndEdit,
                                      isSpecies: widget.isSpecies,
                                    )),
                          );
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
