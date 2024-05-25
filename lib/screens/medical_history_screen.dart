import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/utils/snack.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final auth = FirebaseAuth.instance;

  Color _getDystolicBPColor(int dystolicBP) {
    if (dystolicBP < 70 ||dystolicBP==60) {
      return Colors.orange;
    } else if (dystolicBP > 80) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  Color _getSystolicBPColor(int systolicBP) {
    if (systolicBP < 100 ||systolicBP==90) {
      return Colors.orange;
    } else if (systolicBP > 120) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }


  String formatTimestamp(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the date and time in 12-hour format with AM/PM
    DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }

  String formatDate(String inputDate) {
    // Parse the input date string
    DateTime dateTime =
        DateFormat("dd MMM yyyy 'at' HH:mm:ss 'UTC'Z").parse(inputDate);

    // Format the date and time
    DateFormat formatter = DateFormat('H : mm');
    return formatter.format(dateTime);
  }

  void _deleteDocument(String documentId) async {
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("medicalReports")
        .doc(documentId)
        .delete();

    snackBar(context, "Record deleted successfully");
  } catch (error) {
    print('Error deleting document: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeController>(context, listen: false)
            .primaryColor(context),
        toolbarHeight: 12.h,
        centerTitle: true,
        title: Text(
          "Kidney Scan",
          style: GoogleFonts.pacifico(
            fontSize: 35,
            color: AppColors().white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(auth.currentUser!.uid)
                  .collection("medicalReports")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return  Container(
                    height: 80.h,
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];

                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                           const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        margin:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          children: [
                           const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               const Spacer(),
                               const Icon(Icons.access_alarm),
                               const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  formatTimestamp(doc.get('time')),
                                  style:const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              const  Spacer(),
                                InkWell(
                                    onTap: () {
                                      _deleteDocument(doc.id);
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade300,
                                    ))
                              ],
                            ),
                           const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  // color: Colors.red,
                                  width: 40.w,
                                  child: const Text(
                                    'WaterIntake Level',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                ),
                              const  Spacer(),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  // color: Colors.red,
                                  width: 10.w,
                                  child: Text(
                                      doc.get('waterIntakeLevel').toString()),
                                ),
                               const Spacer(),
                                SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: LiquidCircularProgressIndicator(
                                    value: double.parse(doc.get('waterIntakeLevel')
                                            .toString()) /
                                        200,
                                    valueColor: AlwaysStoppedAnimation(
                                        AppColors().primaryColor),
                                    backgroundColor: AppColors().grey,
                                    borderColor: Colors.black,
                                    borderWidth: 0.1,
                                    direction: Axis.vertical,
                                    center: Text(
                                      "${((double.parse(doc.get('waterIntakeLevel').toString()) / 200) * 100).toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  child:const Text(
                                    'Systolic  BP',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                ),
                             const   Spacer(),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.red,
                                    width: 10.w,
                                    child: Text(
                                        doc.get('systolic BP').toString())),
                              const  Spacer(),
                                Container(
                                  width: 35,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                        color: _getSystolicBPColor(
                                            doc.get('systolic BP')),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            ),
                          const  SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  child:const Text(
                                    'Dystolic  BP',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                ),
                             const   Spacer(),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.red,
                                    width: 10.w,
                                    child: Text(
                                        doc.get('dystolic BP').toString())),
                               const Spacer(),
                                Container(
                                  width: 35,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                        color: _getDystolicBPColor(
                                            doc.get('dystolic BP')),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ));
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
