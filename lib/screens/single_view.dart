import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kidneyscan/controllers/db_controller.dart';
import 'package:kidneyscan/model/kidney_model.dart';
import 'package:provider/provider.dart';

import '../controllers/theme_controller.dart';

class SingleView extends StatefulWidget {
  final KidneyModel reportModel;

  const SingleView({super.key, required this.reportModel});

  @override
  State<SingleView> createState() => _SingleViewState();
}


class _SingleViewState extends State<SingleView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(builder: (context, viewModdel, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'assets/images/close.png',
                      height: 34,
                      width: 34,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/images/k.png',
                  width: 107,
                  height: 35,
                ),
                SizedBox(
                  height: 30,
                ),
                Image.asset('assets/images/dvivinder.png'),
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/patain.png',
                  width: 188,
                  height: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        viewModdel.user!.name.toString(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Email:',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      viewModdel.user!.email.toString(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    Text(
                      'Phone no:',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        viewModdel.user!.phoneNumber.toString(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Image.asset('assets/images/dvivinder.png'),
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/report.png',
                  width: 140,
                  height: 30,
                ),
                SizedBox(
                  height: 20,
                ),

                /// stine class ///
                /// stine class ///
                /// stine class ///

                widget.reportModel.otherClasses!.stone != null
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Disease name:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.reportModel.otherClasses!.stone != null ? "Stone" : "",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Probability:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.reportModel.otherClasses!.stone!.toStringAsFixed(7).toString(),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
                    : SizedBox.shrink(),

                /// tumor class ///
                /// tumor class ///
                /// tumor class ///
                widget.reportModel.otherClasses!.tumor != null
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Disease name:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.reportModel.otherClasses!.tumor != null ? "Tumor" : "",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Probability:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.reportModel.otherClasses!.tumor!.toStringAsFixed(7).toString(),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
                    : SizedBox.shrink(),

                /// normal class ///
                /// normal class ///
                /// normal class ///
                widget.reportModel.otherClasses!.normal != null
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Disease name:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.reportModel.otherClasses!.normal != null ? "Normal" : "",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Probability:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.reportModel.otherClasses!.normal!.toStringAsFixed(7).toString(),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
                    : SizedBox.shrink(),

                /// cyst  class///
                /// cyst  class///
                /// cyst  class///
                /// cyst  class///
                /// cyst  class///

                widget.reportModel.otherClasses!.cyst != null
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Disease name:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.reportModel.otherClasses!.cyst != null ? "Cyst" : "",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Probability:',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${widget.reportModel.otherClasses!.cyst!.toStringAsFixed(7)}',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
                    : SizedBox.shrink(),

                /// predicted class ///
                /// predicted class ///
                /// predicted class ///
                /// predicted class ///
                Row(
                  children: [
                    Text(
                      'Disease name:',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.reportModel.predictedClass.toString(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Probability:',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${widget.reportModel.predictedPercentage!.roundToDouble().toString()}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }  );
  }
}
