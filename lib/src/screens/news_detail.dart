import 'package:flutter/material.dart';

class NewsDetail extends StatelessWidget {
  // Because this is statelesswidget, need to be final
  final int itemId;

  // Constructor
  NewsDetail({this.itemId});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar detects previous navigation and back button gets implemented automagically
        title: Text('Detail'),
      ),
      // Show the itemId
      body: Text('$itemId'),
    );
  }
}
