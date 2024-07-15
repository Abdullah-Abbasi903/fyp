// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:kidneyscan/constants/colors/app_colors.dart';
// import 'package:kidneyscan/controllers/home_controller.dart';
// import 'package:kidneyscan/repo/model_repo.dart';
// import 'package:kidneyscan/screens/single_view.dart';
// import 'package:provider/provider.dart';
//
// import '../model/kidney_model.dart';
//
// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});
//
//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }
//
// class _ReportScreenState extends State<ReportScreen> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _fetchReports();
//     });
//     // TODO: implement initState
//     super.initState();
//   }
//
//   List<ReportModel>? _list;
//   HomeController controller = HomeController();
//
//   Future<void> _fetchReports() async {
//     try {
//       List<ReportModel> reports = await controller.fetchReports();
//       setState(() {
//         _list = reports;
//       });
//       print("__________________data$_list");
//     } catch (e) {
//       print('Error fetching reports: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeController>(
//       builder: (context, value, child) {
//         return Scaffold(
//           backgroundColor: AppColors().white,
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       suffixIcon: Icon(
//                         Icons.search,
//                         color: Colors.black,
//                       ),
//                       hintText: 'Search by name',
//                       hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey.withOpacity(0.7)),
//                       filled: true,
//                       fillColor: Color(0xffDAECF5).withOpacity(0.9),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.white, width: 0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.white, width: 0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.white, width: 0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 _list != null
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           if (_list!.isEmpty) {
//                             return Container(
//                               child: Center(
//                                 child: Text(
//                                   "No Data",
//                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 19),
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return ListTile(
//                                 leading: Image.asset(
//                                   'assets/images/file.png',
//                                   height: 40,
//                                 ),
//                                 title: Row(
//                                   children: [
//                                     Text(
//                                       _list![index].reportsData!.predictedClass.toString(),
//                                       style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
//                                     ),
//                                     Spacer(),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.of(context)
//                                             .push(MaterialPageRoute(builder: (_) => SingleView(reportModel: _list![index])));
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(color: Color(0xffDAECF5), borderRadius: BorderRadius.circular(20)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
//                                           child: Text(
//                                             "VIEW",
//                                             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                         onTap: () {
//                                           value.fetchAndGeneratePdf(_list![index].id);
//                                         },
//                                         child: Image.asset(
//                                           'assets/images/download.png',
//                                           height: 24,
//                                         )),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                         onTap: () {
//                                           value.deleteReportById(_list![index].id);
//                                         },
//                                         child: Image.asset(
//                                           'assets/images/del.png',
//                                           height: 24,
//                                         )),
//                                   ],
//                                 ),
//                                 subtitle: _list![index].time != null ? Text(formatDate(_list![index].time)) : Text("sa"));
//                           }
//                         },
//                         itemCount: _list!.length,
//                       )
//                     : Center(
//                         child: CircularProgressIndicator(),
//                       ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// String formatDate(DateTime dateTime) {
//   DateFormat formatter = DateFormat('MM/dd/yyyy');
//   String formattedDate = formatter.format(dateTime);
//   return formattedDate;
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/home_controller.dart';
import 'package:kidneyscan/screens/single_view.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../model/kidney_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchReports();
    });
    super.initState();
  }

  List<ReportModel>? _list;
  List<ReportModel>? _filteredReports;
  HomeController controller = HomeController();
  TextEditingController _searchController = TextEditingController();

  Future<void> _fetchReports() async {
    try {
      List<ReportModel> reports = await controller.fetchReports();
      setState(() {
        _list = reports;
        _filteredReports = reports;
      });
      print("__________________data$_list");
    } catch (e) {
      print('Error fetching reports: $e');
    }
  }

  void _filterReports(String query) {
    if (_list != null) {
      if (query.isEmpty) {
        setState(() {
          _filteredReports = _list;
        });
      } else {
        setState(() {
          _filteredReports = _list!.where((report) {
            return report.reportsData.predictedClass
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build called again -----");
    return Consumer<HomeController>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors().white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      _filterReports(value);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: 'Search by predicted class',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey.withOpacity(0.7)),
                      filled: true,
                      fillColor: Color(0xffDAECF5).withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 0),
                      ),
                    ),
                  ),
                ),
                _filteredReports != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (_filteredReports!.isEmpty) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "No Data",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.h),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: AppColors().primaryColor,
                                child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/file.png',
                                      height: 40,
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          _filteredReports![index]
                                              .reportsData
                                              .predictedClass
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) => SingleView(
                                                            reportModel:
                                                                KidneyModel(
                                                          otherClasses:
                                                              _filteredReports![
                                                                      index]
                                                                  .reportsData
                                                                  .otherClasses,
                                                          isKidney:
                                                              _filteredReports![
                                                                      index]
                                                                  .reportsData
                                                                  .isKidney,
                                                          predictedClass:
                                                              _filteredReports![
                                                                      index]
                                                                  .reportsData
                                                                  .predictedClass,
                                                          predictedPercentage:
                                                              _filteredReports![
                                                                      index]
                                                                  .reportsData
                                                                  .predictedPercentage,
                                                          predictedSize:
                                                              _filteredReports![
                                                                      index]
                                                                  .reportsData
                                                                  .predictedSize,
                                                        ))));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffDAECF5),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 1),
                                              child: Text(
                                                "VIEW",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              value.genpdf(
                                                  _filteredReports![index]);
                                            },
                                            child: Image.asset(
                                              'assets/images/download.png',
                                              height: 24,
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("Confirm Delete"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          value
                                                              .deleteReportById(
                                                            _filteredReports![
                                                                    index]
                                                                .id,
                                                          );
                                                           Navigator.pop(context);
                                                           setState(() {
                                                             
                                                           });
                                                        },
                                                        child: Text("confirm"),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/images/del.png',
                                              height: 24,
                                            )),
                                      ],
                                    ),
                                    subtitle:
                                        _filteredReports![index].time != null
                                            ? Text(formatDate(
                                                _filteredReports![index].time))
                                            : Text("sa")),
                              ),
                            );
                          }
                        },
                        itemCount: _filteredReports!.length,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String formatDate(DateTime dateTime) {
  DateFormat formatter = DateFormat('MM/dd/yyyy');
  String formattedDate = formatter.format(dateTime);
  return formattedDate;
}
