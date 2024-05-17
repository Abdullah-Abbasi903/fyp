import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// class HomeController extends ChangeNotifier{

//   File? _image;

//   bool _loading = false;

//   File? get image => _image;

//   bool get loading => _loading;

//   setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }

//   Future<void> getImage(ImageSource source) async {
//     setLoading(true);
//     final imagePick = ImagePicker();
//     final pickedImage = await imagePick.pickImage(source: source);
//     if (pickedImage != null) {
//       _image = File(pickedImage.path);
//       setLoading(false);
//     } else {

//     }
//     setLoading(false);
//   }

// }

///////////////////////

class HomeController extends ChangeNotifier {
  File? _image;
  bool _loading = false;

  File? get image => _image;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getImage(ImageSource source) async {
    setLoading(true);
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        if (decodedImage.width != 512 || decodedImage.height != 512) {
          print("image is in width: ${decodedImage.width} and height: ${decodedImage.height}");
          decodedImage = img.copyResize(decodedImage, width: 512, height: 512);
          print("converted image width: ${decodedImage.width} and height: ${decodedImage.height}");
        }
        // Save the resized image
        final resizedBytes = img.encodePng(decodedImage);
        _image = File(pickedImage.path)
          ..writeAsBytesSync(resizedBytes);
      } else {
        print("Failed to decode image");
      }
    } else {
      print("No image picked");
    }
    setLoading(false);
  }
}
