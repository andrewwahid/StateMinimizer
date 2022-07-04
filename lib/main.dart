import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:implication_solver/Pages/TruthTable/TruthTableInfoPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Implication Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TruthTableInfoPage(),
    );
  }
}
