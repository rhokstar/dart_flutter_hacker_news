// Show grey rectangles until data loads

import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  Widget build(context) {
    return Column(
      children: [
        ListTile(
          // Show the grey rectangles
          title: buildContainer(),
          subtitle: buildContainer(),
        ),
        Divider(height: 8.0),
      ],
    );
  }

  // Helper method
  Widget buildContainer() {
    return Container(
      color: Colors.grey[300], // you can also use a specific shade of grey
      height: 24.0,
      width: 150.0,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}