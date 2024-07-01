import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kidneyscan/controllers/notification_controller.dart';
import 'package:kidneyscan/model/kidney_model.dart';
import 'package:kidneyscan/repo/model_repo.dart';
import 'package:kidneyscan/screens/single_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/widgets.dart' as pw;


class HomeController extends ChangeNotifier {
  File? _image;

  bool _loading = false;

  File? get image => _image;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<void> generatePdf(ReportModel report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Report ID: ${report.id}"),
              pw.Text("Time: ${report.time}"),
              pw.SizedBox(height: 20),
              pw.Text("Report Data"),
              pw.Text("Is Kidney: ${report.reportsData.isKidney}"),
              pw.Text("Predicted Class: ${report.reportsData.predictedClass}"),
              pw.Text("Predicted Percentage: ${report.reportsData.predictedPercentage}"),
              pw.Text("Predicted Size: ${report.reportsData.predictedSize}"),
              pw.SizedBox(height: 20),
              pw.Text("Other Classes"),
              pw.Text("Cyst: ${report.reportsData.otherClasses.cyst}"),
              pw.Text("Normal: ${report.reportsData.otherClasses.normal}"),
              pw.Text("Tumor: ${report.reportsData.otherClasses.tumor}"),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/report.pdf");
    await file.writeAsBytes(await pdf.save());
    print("PDF saved at ${file.path}");
  }
  ApiManager apiManager = ApiManager();

  Future<void> apiCall(File image, BuildContext context) async {
    var id = FirebaseAuth.instance.currentUser!.uid.toString();
    try {
      // KidneyModel newModel = KidneyModel();
      var udid = Uuid().v4();
      setLoading(true);
      var res = await apiManager.uploadImageAndGetPrediction(image);
      if (res.otherClasses != null &&
          res.isKidney == true &&
          res.predictedClass != null &&
          res.predictedClass.toString() != "") {
        Map<String, dynamic> modelData = res.toJson();

        DocumentReference docRef = FirebaseFirestore.instance.collection('reports').doc(id);

        // Append the data to the existing list
        await docRef.update({
          "reports": FieldValue.arrayUnion([
            {"reportsData": modelData, "id": udid, "time": DateTime.now()}
          ])
        }).catchError((error) async {
          // If the document does not exist, create it and then append
          if (error is FirebaseException && error.code == 'not-found') {
            await docRef.set({
              "reports": FieldValue.arrayUnion([
                {"reportsData": modelData, "id": udid, "time": DateTime.now()}
              ])
            });
          } else {
            throw error;
          }
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SingleView(reportModel: res)));
        print('Data successfully appended!');
        // newModel  = res;
        _image = null;
        // image = null;
        notifyListeners();
        // db.doc(id).set({
        //   "reports": FieldValue.arrayUnion([
        //     {"reportsData": modelData,"id":uuid.v4()}
        //   ])
        // });
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report Generated Successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The image is not a kidney")));
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print('Error uploading image or getting prediction: $e');
    }
  }
  //   Future<void> fetchAndGeneratePdf(String reportId) async {
  //   try {
  //     String userId = FirebaseAuth.instance.currentUser!.uid;
  //     DocumentReference docRef = FirebaseFirestore.instance.collection('reports').doc(userId);
  //     DocumentSnapshot snapshot = await docRef.get();
  //
  //     if (snapshot.exists) {
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //       List<dynamic> reportsList = data['reports'] ?? [];
  //
  //       Map<String, dynamic>? reportData;
  //       for (var report in reportsList) {
  //         if (report['id'] == reportId) {
  //
  //           reportData = report;
  //           break;
  //         }
  //       }
  //
  //       if (reportData != null) {
  //         ReportModel report = ReportModel.fromJson(reportData);
  //         await generatePdf(report);
  //         print('sadadasdadas');
  //         print(report.id.toString());
  //       } else {
  //         print("Report with ID $reportId not found.");
  //       }
  //     } else {
  //       print("User document does not exist.");
  //     }
  //   } catch (e) {
  //     print('Error fetching reports: $e');
  //     throw e;
  //   }
  // }





  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String filePath) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'PDF Saved',
        body: 'Your PDF has been saved. Click to open.',
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [

        NotificationActionButton(


          key: 'OPEN_PDF',
          label: 'Open PDF',

        ),
      ],
    );
  }

  Future<void> requestStoragePermissions() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      return;
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    if (statuses[Permission.manageExternalStorage]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      print("Permissions granted");
    } else {
      print("Permissions not granted");
    }
  }

  Future<void> genpdf(ReportModel report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Report ID: ${report.id}"),
              pw.Text("Time: ${report.time}"),
              pw.SizedBox(height: 20),
              pw.Text("Report Data"),
              pw.Text("Is Kidney: ${report.reportsData.isKidney}"),
              pw.Text("Predicted Class: ${report.reportsData.predictedClass}"),
              pw.Text("Predicted Percentage: ${report.reportsData.predictedPercentage}"),
              pw.Text("Predicted Size: ${report.reportsData.predictedSize}"),
              pw.SizedBox(height: 20),
              pw.Text("Other Classes"),
              pw.Text("Cyst: ${report.reportsData.otherClasses.cyst}"),
              pw.Text("Normal: ${report.reportsData.otherClasses.normal}"),
              pw.Text("Tumor: ${report.reportsData.otherClasses.tumor}"),
            ],
          );
        },
      ),
    );

    await requestStoragePermissions();

    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Documents');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory != null && await directory.exists()) {
      final file = File("${directory.path}/report_${report.id}.pdf");
      await file.writeAsBytes(await pdf.save());
      print("PDF saved at ${file.path}");
      NotificationController.pat = file.path;

      await showNotification(file.path);
    } else {
      print("Could not access the documents folder.");
    }
  }

  Future<void> fetchAndGeneratePdf(String reportId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference docRef = FirebaseFirestore.instance.collection('reports').doc(userId);
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> reportsList = data['reports'] ?? [];

        Map<String, dynamic>? reportData;
        for (var report in reportsList) {
          if (report['id'] == reportId) {
            reportData = report;
            break;
          }
        }

        if (reportData != null) {
          ReportModel report = ReportModel.fromJson(reportData);
          await generatePdf(report);
        } else {
          print("Report with ID $reportId not found.");
        }
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw e;
    }
  }















  /// new
  /// new
  /// new
//   Future<void> requestStoragePermissions() async {
//     if (await Permission.manageExternalStorage.request().isGranted) {
//       return;
//     }
//
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.storage,
//       Permission.manageExternalStorage,
//     ].request();
//
//     if (statuses[Permission.manageExternalStorage]!.isGranted &&
//         statuses[Permission.storage]!.isGranted) {
//       print("Permissions granted");
//     } else {
//       print("Permissions not granted");
//     }
//   }
// /// new
//   Future<void> genpdf(ReportModel report) async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text("Report ID: ${report.id}"),
//               pw.Text("Time: ${report.time}"),
//               pw.SizedBox(height: 20),
//               pw.Text("Report Data"),
//               pw.Text("Is Kidney: ${report.reportsData.isKidney}"),
//               pw.Text("Predicted Class: ${report.reportsData.predictedClass}"),
//               pw.Text("Predicted Percentage: ${report.reportsData.predictedPercentage}"),
//               pw.Text("Predicted Size: ${report.reportsData.predictedSize}"),
//               pw.SizedBox(height: 20),
//               pw.Text("Other Classes"),
//               pw.Text("Cyst: ${report.reportsData.otherClasses.cyst}"),
//               pw.Text("Normal: ${report.reportsData.otherClasses.normal}"),
//               pw.Text("Tumor: ${report.reportsData.otherClasses.tumor}"),
//             ],
//           );
//         },
//       ),
//     );
//
//     await requestStoragePermissions();
//
//     Directory? directory;
//     if (Platform.isAndroid) {
//       directory = Directory('/storage/emulated/0/Documents');
//     } else {
//       directory = await getApplicationDocumentsDirectory();
//     }
//
//     if (directory != null && await directory.exists()) {
//       final file = File("${directory.path}/report_${report.id}.pdf");
//       await file.writeAsBytes(await pdf.save());
//       print("PDF saved at ${file.path}");
//     } else {
//       print("Could not access the documents folder.");
//     }
//   }
//
//

  /// new
  // Future<void> fetchAndGeneratePdf(String reportId) async {
  //   try {
  //     String userId = FirebaseAuth.instance.currentUser!.uid;
  //     DocumentReference docRef = FirebaseFirestore.instance.collection('reports').doc(userId);
  //     DocumentSnapshot snapshot = await docRef.get();
  //
  //     if (snapshot.exists) {
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //       List<dynamic> reportsList = data['reports'] ?? [];
  //
  //       Map<String, dynamic>? reportData;
  //       for (var report in reportsList) {
  //         if (report['id'] == reportId) {
  //           reportData = report;
  //           break;
  //         }
  //       }
  //
  //       if (reportData != null) {
  //         ReportModel report = ReportModel.fromJson(reportData);
  //         await generatePdf(report);
  //       } else {
  //         print("Report with ID $reportId not found.");
  //       }
  //     } else {
  //       print("User document does not exist.");
  //     }
  //   } catch (e) {
  //     print('Error fetching reports: $e');
  //     throw e;
  //   }
  // }



  Future<List<ReportModel>> fetchReports() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      // Get the document reference
      DocumentReference docRef = FirebaseFirestore.instance.collection('reports').doc(userId);

      // Get the document snapshot
      DocumentSnapshot snapshot = await docRef.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Get the data from the document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Extract the reports list
        List<dynamic> reportsList = data['reports'] ?? [];

        // Convert each entry in the reports list to a ReportModel object
        List<ReportModel> reports = reportsList.map((reportData) {
          return ReportModel.fromJson(reportData);
        }).toList();

        return reports;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw e;
    }
  }

  // Future<List<ReportModel>> fetchReports() async {
  //   try {
  //     var a = FirebaseAuth.instance.currentUser!.uid.toString();
  //     // Get the document reference
  //     DocumentReference docRef = FirebaseFirestore.instance.collection('reports').doc("7tP0jQgh0oPC42fXQiaz1n3acez2");
  //
  //     // Get the document snapshot
  //     DocumentSnapshot snapshot = await docRef.get();
  //
  //     // Check if the document exists
  //     if (snapshot.exists) {
  //       // Get the data from the document
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //
  //       // Extract the reports list
  //       List<dynamic> reportsList = data['reports'] ?? [];
  //
  //       // Convert each entry in the reports list to a KidneyModel object
  //       List<ReportModel> reports = reportsList.map((reportData) {
  //         return ReportModel.fromJson(reportData['reportsData']);
  //       }).toList();
  //
  //       return reports;
  //     } else {
  //       throw Exception("Document does not exist");
  //     }
  //   } catch (e) {
  //     print('Error fetching reports: $e');
  //     throw e;
  //   }
  // }

  Future<void> getImage(ImageSource source) async {
    setLoading(true);
    final imagePick = ImagePicker();
    final pickedImage = await imagePick.pickImage(source: source);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
      setLoading(false);
    } else {}
    setLoading(false);
  }














  Future<void> deleteReportById(String reportId) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the document reference for the current user
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('reports').doc(userId);

      // Use a transaction to safely read and update the document
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the document snapshot
        DocumentSnapshot snapshot = await transaction.get(userDocRef);

        if (snapshot.exists) {
          // Get the data from the document
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // Extract the reports list
          List<dynamic> reportsList = data['reports'] ?? [];

          // Find the report to delete
          Map<String, dynamic>? reportToDelete;
          for (var report in reportsList) {
            if (report['id'] == reportId) {
              reportToDelete = report;
              break;
            }
          }

          if (reportToDelete != null) {
            // Remove the report from the array
            transaction.update(userDocRef, {
              'reports': FieldValue.arrayRemove([reportToDelete]),
            });
            fetchReports();
            print("Report with ID $reportId deleted successfully.");
          } else {
            print("Report with ID $reportId not found.");
          }
        } else {
          print("User document does not exist.");
        }
      });
    } catch (e) {
      print('Error deleting report: $e');
      throw e;
    }
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
