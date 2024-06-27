import 'package:cloud_firestore/cloud_firestore.dart';

class KidneyModel {
  bool? isKidney;
  OtherClasses? otherClasses;
  String? predictedClass;
  double? predictedPercentage;
  double? predictedSize;

  KidneyModel({this.isKidney, this.otherClasses, this.predictedClass, this.predictedPercentage, this.predictedSize});

  KidneyModel.fromJson(Map<String, dynamic> json) {
    isKidney = json['is_kidney'];
    otherClasses = json['other_classes'] != null ? new OtherClasses.fromJson(json['other_classes']) : null;
    predictedClass = json['predicted_class'];
    predictedPercentage = json['predicted_percentage'];
    predictedSize = json['predicted_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_kidney'] = this.isKidney;
    if (this.otherClasses != null) {
      data['other_classes'] = this.otherClasses!.toJson();
    }
    data['predicted_class'] = this.predictedClass;
    data['predicted_percentage'] = this.predictedPercentage;
    data['predicted_size'] = this.predictedSize;
    return data;
  }
}

class OtherClasses {
  double? cyst;
  double? normal;
  double? tumor;

  OtherClasses({this.cyst, this.normal, this.tumor});

  OtherClasses.fromJson(Map<String, dynamic> json) {
    cyst = json['Cyst'];
    normal = json['Normal'];
    tumor = json['Tumor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Cyst'] = this.cyst;
    data['Normal'] = this.normal;
    data['Tumor'] = this.tumor;
    return data;
  }
}

// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// neww
// class ReportModel {
//   String? id;
//   ReportData? reportsData;
//   // DateTime? time;
//
//   ReportModel({
//     required this.id,
//     required this.reportsData,
//     // required this.time,
//   });
//
//   factory ReportModel.fromJson(Map<String, dynamic> json) {
//     return ReportModel(
//       id: json['id'] ?? '',
//       reportsData: ReportData.fromJson(json['reportsData'] ?? {}),
//       // time: DateTime.parse(json['time'] ?? ""),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'reportsData': reportsData!.toJson(),
//       // 'time': time,
//     };
//   }
// }
//
// class ReportData {
//   bool isKidney;
//   OtherClasses otherClasses;
//   String predictedClass;
//   double predictedPercentage;
//   double predictedSize;
//
//   ReportData({
//     required this.isKidney,
//     required this.otherClasses,
//     required this.predictedClass,
//     required this.predictedPercentage,
//     required this.predictedSize,
//   });
//
//   factory ReportData.fromJson(Map<String, dynamic> json) {
//     return ReportData(
//       isKidney: json['is_kidney'] ?? false,
//       otherClasses: OtherClasses.fromJson(json['other_classes'] ?? {}),
//       predictedClass: json['predicted_class'] ?? '',
//       predictedPercentage: (json['predicted_percentage'] ?? 0.0).toDouble(),
//       predictedSize: (json['predicted_size'] ?? 0.0).toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'is_kidney': isKidney,
//       'other_classes': otherClasses.toJson(),
//       'predicted_class': predictedClass,
//       'predicted_percentage': predictedPercentage,
//       'predicted_size': predictedSize,
//     };
//   }
// }
//
// class NewOtherClasses {
//   double? cyst;
//   double? normal;
//   double? tumor;
//
//   NewOtherClasses({
//     this.cyst,
//     this.normal,
//     this.tumor,
//   });
//
//   factory NewOtherClasses.fromJson(Map<String, dynamic> json) {
//     return NewOtherClasses(
//       cyst: (json['Cyst'] ?? 0.0).toDouble(),
//       normal: (json['Normal'] ?? 0.0).toDouble(),
//       tumor: (json['Tumor'] ?? 0.0).toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Cyst': cyst,
//       'Normal': normal,
//       'Tumor': tumor,
//     };
//   }
// }



class ReportModel {
  String id;
  ReportData reportsData;
  DateTime time;

  ReportModel({
    required this.id,
    required this.reportsData,
    required this.time,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    Timestamp timestamp = json['time'];
    return ReportModel(
      id: json['id'] ?? '',
      reportsData: ReportData.fromJson(json['reportsData'] ?? {}),
      time: timestamp.toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportsData': reportsData.toJson(),
      'time': Timestamp.fromDate(time), // Convert DateTime to Firestore Timestamp
    };
  }
}

class ReportData {
  bool isKidney;
  OtherClasses otherClasses;
  String predictedClass;
  double predictedPercentage;
  double predictedSize;

  ReportData({
    required this.isKidney,
    required this.otherClasses,
    required this.predictedClass,
    required this.predictedPercentage,
    required this.predictedSize,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      isKidney: json['is_kidney'] ?? false,
      otherClasses: OtherClasses.fromJson(json['other_classes'] ?? {}),
      predictedClass: json['predicted_class'] ?? '',
      predictedPercentage: (json['predicted_percentage'] ?? 0.0).toDouble(),
      predictedSize: (json['predicted_size'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_kidney': isKidney,
      'other_classes': otherClasses.toJson(),
      'predicted_class': predictedClass,
      'predicted_percentage': predictedPercentage,
      'predicted_size': predictedSize,
    };
  }
}

class NewOtherClasses {
  double? cyst;
  double? normal;
  double? tumor;

  NewOtherClasses({
    this.cyst,
    this.normal,
    this.tumor,
  });

  factory NewOtherClasses.fromJson(Map<String, dynamic> json) {
    return NewOtherClasses(
      cyst: (json['Cyst'] ?? 0.0).toDouble(),
      normal: (json['Normal'] ?? 0.0).toDouble(),
      tumor: (json['Tumor'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Cyst': cyst,
      'Normal': normal,
      'Tumor': tumor,
    };
  }
}
