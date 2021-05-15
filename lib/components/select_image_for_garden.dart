import 'dart:typed_data';

import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/screens/account_page/image_picker_page.dart';
import 'package:flutter/material.dart';

/// Display Current garden image as button, that leads to changing the garden Image
class select_garden_image extends StatefulWidget {
  /// Display Current garden image as button, that leads to changing the garden Image
  select_garden_image({
    Key key,
    @required this.garden,
    @required this.deleteFunction,
    @required this.saveFunction,
    @required this.toSaveImage,
  }) : super(key: key);

  ///describes the garden for which the image is being edited
  final Garden garden;

  /// the function that is called to delete the originalimage
  final Function(String toDeleteURL) deleteFunction;

  /// the function that is called to acquire the new imageData
  final Function(Uint8List rawImageData) saveFunction;

  /// The image that will be saved upon saveCallback. used to Display
  Uint8List toSaveImage;

  @override
  _select_garden_imageState createState() => _select_garden_imageState();
}

class _select_garden_imageState extends State<select_garden_image> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePickerPage(
              originalImageURL: widget.garden.imageURL,
              deleteImageFunction: widget.deleteFunction,
              saveImageFunction: widget.saveFunction,
            ),
          ),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Theme.of(context).canvasColor.withOpacity(0.4),
                BlendMode.dstATop),
            child: widget.toSaveImage != null
                ? Image.memory(
                    widget.toSaveImage,
                  )
                : Image.network(widget.garden.imageURL, errorBuilder:
                    (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                    return Image(
                        color: Theme.of(context).canvasColor.withOpacity(1),
                        colorBlendMode: BlendMode.saturation,
                        image: const AssetImage('res/Logo_basic.png'));
                  }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image_outlined,
                color: Colors.black,
              ),
              const Text(
                'Titelfoto wechseln',
                style: TextStyle(color: Colors.black),
                textScaleFactor: 1.5,
              ),
            ],
          )
        ],
      ),
    );
  }
}
