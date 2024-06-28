import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kidneyscan/model/kidney_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManager {
static String url = "http://192.168.100.13:5000/predict";
Future<KidneyModel> uploadImageAndGetPrediction(File imageFile) async {

  // Create a multipart request
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(url),
  );

  // Add headers

  // Add file
  var fileStream = http.ByteStream(imageFile.openRead());
  var length = await imageFile.length();
  var multipartFile = http.MultipartFile(
    'image',
    fileStream,
    length,
    filename: imageFile.path.split('/').last,
  );

  // Add the file to the request
  request.files.add(multipartFile);

  // Send request
  var response = await request.send();

  // Check response status
  if (response.statusCode == 200) {
    // Successful upload
    var responseData = await response.stream.bytesToString();
    print("Upload response: $responseData");

    // Parse the JSON response into a KidneyModel object
    Map<String, dynamic> jsonResponse = jsonDecode(responseData);
    KidneyModel kidneyModel = KidneyModel.fromJson(jsonResponse);

    return kidneyModel;
  } else {
    // Error during upload
    throw Exception('Failed to upload image: ${response.statusCode}');
  }
}
}
