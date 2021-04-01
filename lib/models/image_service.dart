import 'dart:developer' as logging;
import 'dart:io';

import 'package:biodiversity/models/storage_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Service which holds the image urls and copyright information
/// This helps to reduce loading times
class ImageService extends ChangeNotifier {
  final StorageProvider _storage;
  final Map<String, String> _urls = <String, String>{};
  final Map<String, String> _copyrightInfo = <String, String>{};

  /// Service which holds the image urls and copyright information
  ImageService(this._storage) {
    _storage.database
        .collection('imageReferences')
        .snapshots()
        .listen((change) {
      for (final doc in change.docs) {
        if (doc.data().containsKey('downloadURL')) {
          _urls[doc.reference.id] = doc.data()['downloadURL'];
        }
        if (doc.data().containsKey('copyright')) {
          _copyrightInfo[doc.reference.id] = doc.data()['copyright'];
        }
      }
    });
  }

  String _key(String name, String type, {int imageNr}) {
    if (imageNr != null) return '$type$name-$imageNr';
    return '$type$name';
  }

  /// Returns an image which is loaded dynamically from the database/firestore
  Widget getImage(String name, String type,
      {int imageNr,
      double width = double.infinity,
      double height,
      BoxFit fit = BoxFit.fitWidth,
      bool displayCopyrightInfo = false,
      AlignmentGeometry copyrightAlignment = AlignmentDirectional.bottomEnd}) {
    final key = _key(name, type, imageNr: imageNr);

    Widget _getImage(String url) {
      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: url,
        cacheKey: key,
      );
    }

    Widget _getImageWithCopyright(String url, String copyright) {
      return Stack(
        alignment: copyrightAlignment,
        children: [
          _getImage(_urls[key]),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(_copyrightInfo[key]),
          )
        ],
      );
    }

    //shortcut loading to prevent the appearance of circularProgressIndicator
    if (_urls.containsKey(key)) {
      if (!displayCopyrightInfo) {
        return _getImage(_urls[key]);
      } else if (_copyrightInfo.containsKey(key)) {
        return _getImageWithCopyright(_urls[key], _copyrightInfo[key]);
      }
    }

    return FutureBuilder(
      future: getImageURL(name, type),
      builder: (context, url) {
        if (url.connectionState == ConnectionState.done && !url.hasError) {
          if (displayCopyrightInfo) {
            return FutureBuilder(
                future: getImageCopyright(name, type),
                builder: (context, copyright) {
                  if (copyright.connectionState == ConnectionState.done &&
                      !copyright.hasError) {
                    return _getImageWithCopyright(url.data, copyright.data);
                  } else {
                    return Container(
                      child: const CircularProgressIndicator(),
                      width: width,
                      height: height,
                    );
                  }
                });
          } else {
            return _getImage(url.data);
          }
        } else {
          return Container(
              child: const CircularProgressIndicator(),
              width: width,
              height: height);
        }
      },
    );
  }

  /// Returns the image referenced by the provided URL
  Widget getImageByUrl(String url,
      {int imageNr,
      double width = double.infinity,
      double height,
      BoxFit fit = BoxFit.fitWidth,
      AlignmentGeometry copyrightAlignment = AlignmentDirectional.bottomEnd}) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: url,
      cacheKey: url,
      errorWidget: (context, str, error) => getImage('default', 'error'),
    );
  }

  /// returns the associated download link to the name<br>
  /// Example name: Asthaufen<br>
  /// Example type: biodiversityMeasures
  Future<String> getImageURL(String name, String type, {int imageNr}) async {
    final key = _key(name, type, imageNr: imageNr);
    if (_urls.containsKey(key)) {
      return _urls[key];
    }
    final doc = await _storage.database.doc('imageReferences/$key').get();
    if (!doc.exists || !doc.data().containsKey('downloadURL')) {
      if (name != 'default') {
        final url = await getImageURL('default', '');
        if (url != null) _urls[key] = url;
        return url;
      }
      logging.log('default image source not found', level: 100);
      return null;
    }
    _urls[key] = doc.data()['downloadURL'];
    return doc.data()['downloadURL'];
  }

  /// returns copyright information about the image associated with that name
  /// and type. <br>
  /// Example name: Asthaufen<br> Example type: biodiversityMeasures
  Future<String> getImageCopyright(String name, String type,
      {int imageNr}) async {
    final key = _key(name, type, imageNr: imageNr);
    if (_copyrightInfo.containsKey(key)) {
      return _copyrightInfo[key];
    }
    final doc = await _storage.database.doc('imageReferences/$key').get();
    if (!doc.exists || !doc.data().containsKey('copyright')) {
      if (name != 'default') {
        final copyright = await getImageCopyright('default', '');
        if (copyright != null) _copyrightInfo[key] = copyright;
        return copyright;
      }
      logging.log('default image copyright not found', level: 100);
      return '';
    }
    _copyrightInfo[key] = doc.data()['copyright'];
    return doc.data()['copyright'];
  }

  /// Handles the upload of an image to firestore.
  /// Any existing image with the same name will be overridden<br>
  /// Returns the download URL of the image. <br>
  /// The bucket parameter will dictate which folder will be used.
  /// Example: user/{USERID} would create a folder user
  /// and for each user id another subfolder
  Future<String> uploadImage(File file, String bucket,
      {String filename, int quality = 80, int minImageSize = 500}) async {
    // Resize image to make sure its smaller than the maxSize
    final tempPath = (await getTemporaryDirectory()).path;
    var uploadImage = await FlutterImageCompress.compressAndGetFile(
        file.path, '$tempPath/temp.jpeg',
        minHeight: minImageSize, minWidth: minImageSize, quality: quality);

    // upload of the file
    final reference =
        _storage.fileStorage.ref().child('userUpload/$bucket/$filename');
    final task = reference.putFile(uploadImage);
    final docRef = await task.onComplete;
    File('$tempPath/temp.jpeg').delete();
    return await docRef.ref.getDownloadURL();
  }
}
