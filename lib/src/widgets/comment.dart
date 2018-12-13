import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  // Represents the comment of the widget to show and also show their children
  final int itemId;

  // Get the cache map also
  final Map<int, Future<ItemModel>> itemMap;

  // Constructor
  Comment({this.itemId, this.itemMap});

  Widget build(context) {
    // Waiting for the Futures to return
    return FutureBuilder(
      // Look for the itemId in itemMap
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel>snapshot) {
        if(!snapshot.hasData) {
          return Text('Still loading...');
        }

        return Text(snapshot.data.text);
      },
    );
  }
}