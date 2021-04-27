import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Picks an Image from either the camera or the gallery
class ImagePickerPage extends StatefulWidget {
  /// Picks an Image from either the camera or the gallery
  const ImagePickerPage({Key key}) : super(key: key);

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File _imageFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView(
            children: <Widget>[
              if (_imageFile == null)
                const Placeholder()
              else
                Image.file(_imageFile),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: () async => _pickImageFromCamera(),
                tooltip: 'Foto aufnehmen',
              ),
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: () async => _pickImageFromGallery(),
                tooltip: 'Foto aus der Galerie wählen',
              ),
            ],
          ),
        ],
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
