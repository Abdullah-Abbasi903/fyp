import 'package:flutter/material.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors().white,
      body: const Center(child: Text('This is report screen'),),
    );
  }
}