import 'dart:io';

import 'package:biodiversity/components/edit_dialog.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Picks an Image from either the camera or the gallery
class ImagePickerPage extends StatefulWidget {
  ///Describes the ratio between height and width for the cropped image. By default the ratio is variable
  final double aspectRatio;

  ///URL of the image to replace. To add a new picture without replacing one, use default (null)
  final String originalImageURL;

  /// Picks an Image from either the camera or the gallery
  ImagePickerPage({Key key, this.aspectRatio, this.originalImageURL})
      : super(key: key);

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File _imageFile;
  final _picker = ImagePicker();
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    //_editorKey.currentState.rawImageData.hashCode;
    //TODO if image given, load, enable edit, then enable save
    return EditDialog(
      abortCallback: () {
        Navigator.of(context).pop();
      },
      saveCallback: _imageFile == null
          ? null
          : () async {
              _imageFile = File.fromRawPath(_editorKey.currentState
                  .rawImageData); // save locally? check if it changed (button to start editing)
              if (_imageFile != null) {
                final _imageUrl = await ServiceProvider.instance.imageService
                    .uploadImage(_imageFile, 'profilepictures',
                        compress: false,
                        filename:
                            '${user.name}_${user.surname}_${const Uuid().v4()}');
                user.imageURL = _imageUrl;
                Navigator.of(context)
                    .pop(); //TODO white redirect page and if pic not changed => snackbar
                //TODO remove old picture from database
              }
              ;
            },
      title: 'Bild auswählen',
      isScrollable: false,
      body: SizedBox(
        child: Column(
          children: <Widget>[
            if (widget.originalImageURL != null && _imageFile == null)
              OutlinedButton.icon(
                  onPressed: () {
                    get(Uri.parse(widget.originalImageURL)).then((value) {
                      setState(() {
                        //TODO save image from url and setState | make if for network image editing
                        _imageFile = File.fromRawPath(value.bodyBytes);
                      });
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Bearbeiten')),
            if (_imageFile != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.rotate_left),
                      onPressed: () =>
                          _editorKey.currentState.rotate(right: false)),
                  IconButton(
                      icon: const Icon(Icons.restore),
                      onPressed: () => _editorKey.currentState.reset()),
                  IconButton(
                      icon: const Icon(Icons.rotate_right),
                      onPressed: () => _editorKey.currentState.rotate())
                ],
              ),
            if (widget.originalImageURL == null && _imageFile == null)
              const Expanded(
                child: Image(image: AssetImage('res/logo.png')),
              )
            else if (widget.originalImageURL != null && _imageFile == null)
              Expanded(
                child: Image.network(widget.originalImageURL),
              )
            else
              Expanded(
                child: ExtendedImage.file(
                  _imageFile,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: _editorKey,
                  cacheRawData: true,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                      //maxScale: 8.0,
                      cropAspectRatio: widget.aspectRatio,
                    );
                  },
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      OutlinedButton.icon(
                          onPressed: () async => _pickImageFromCamera(),
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Kamera')),
                      if (_imageFile != null)
                        OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                            //TODO Remove Image => onSaved Remove from database
                            icon: const Icon(Icons.delete),
                            label: const Text('Entfernen')),
                      OutlinedButton.icon(
                          onPressed: () async => _pickImageFromGallery(),
                          icon: const Icon(Icons.photo),
                          label: const Text('Galerie')),
                      //TODO add remove image option
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}
