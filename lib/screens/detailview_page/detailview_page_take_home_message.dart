import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/image_service.dart';
import 'package:biodiversity/models/take_home_message.dart';
import 'package:biodiversity/screens/take_home_message_page/take_home_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// Shows the details of a BiodiversityMeasure
class DetailViewPageTakeHomeMessage extends StatefulWidget {
  /// The BiodiversityMeasure element which will be displayed
  final TakeHomeMessage element;

  /// Shows the details of a BiodiversityMeasure
  const DetailViewPageTakeHomeMessage(this.element, {Key key})
      : super(key: key);

  @override
  _DetailViewPageTakeHomeMessageState createState() =>
      _DetailViewPageTakeHomeMessageState();
}

class _DetailViewPageTakeHomeMessageState
    extends State<DetailViewPageTakeHomeMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details: ${widget.element.title}')),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<ImageService>(context, listen: false).getImage(
              widget.element.title,
              'takeHomeMessage',
              height: 150,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.element.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          softWrap: true,
                        ),
                      ),
                      Row(children: [
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : Navigator.push(
                                context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TakeHomeMessagePage()),
                                    );
                            }),
                      ])
                    ],
                  ),
                  MarkdownBody(data: widget.element.description),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
