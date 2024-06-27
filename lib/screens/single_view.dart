import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kidneyscan/model/kidney_model.dart';

class SingleView extends StatefulWidget {
  final ReportModel reportModel;

  const SingleView({super.key, required this.reportModel});

  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  'Muhammad Saqib Nisar',
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
                  'abbasiabdullah672@gmail.com',
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
                  'Gender:',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Male',
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
                  '03150526683',
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
                  widget.reportModel.reportsData.predictedSize.toString(),
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
                  widget.reportModel.reportsData.predictedSize.toString(),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
                  widget.reportModel.reportsData.otherClasses.normal.toString(),
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
                  widget.reportModel.reportsData.predictedPercentage.toString(),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
                  widget.reportModel.reportsData.otherClasses.tumor.toString(),
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
                  '${widget.reportModel.reportsData.otherClasses.normal}',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
