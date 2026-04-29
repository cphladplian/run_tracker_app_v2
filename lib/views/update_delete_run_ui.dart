import 'package:flutter/material.dart';

class UpdateDeleteRunUi extends StatefulWidget {
  final Map<String, dynamic> run; //เพิ่มตัวแปร รับข้อมูล
  const UpdateDeleteRunUi({super.key, required this.run});

  @override
  State<UpdateDeleteRunUi> createState() => _UpdateDeleteRunUiState();
}

class _UpdateDeleteRunUiState extends State<UpdateDeleteRunUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}