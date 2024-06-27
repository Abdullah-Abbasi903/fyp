import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends ChangeNotifier{

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
    final imagePick = ImagePicker();
    final pickedImage = await imagePick.pickImage(source: source);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
      setLoading(false);
    } else {

    }
    setLoading(false);
  }

}

///////////////////////

// class HomeController extends ChangeNotifier {
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
//     final imagePicker = ImagePicker();
//     final pickedImage = await imagePicker.pickImage(source: source);
    
//     setLoading(false);
//   }
// }
