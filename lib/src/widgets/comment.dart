import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../widgets/loading_container.dart';

class Comment extends StatelessWidget {
  // Represents the comment of the widget to show and also show their children
  final int itemId;

  // Get the cache map also
  final Map<int, Future<ItemModel>> itemMap;

  // Provides depth of indentation of comments 0, 1, 2, 3. This gets included into the Comment args.
  // Make sure to add depth arg where ever comments are shown
  final int depth;

  // Constructor
  Comment({this.itemId, this.itemMap, this.depth});

  Widget build(context) {
    // Waiting for the Futures to return
    return FutureBuilder(
      // Look for the itemId in itemMap
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        // If data hasn't shown...
        if (!snapshot.hasData) {
          // ...show loading container
          return LoadingContainer();
        }

        // Instead of using snapshot.data
        final item = snapshot.data;

        // Prepare list of children
        final children = <Widget>[
          ListTile(
            // Display comment body that cleans up HTML within the comments
            // Helper method
            title: buildText(item),
            // Display the author using 'by'
            subtitle: item.by == ""
                // Ternary expression for deleted comments
                ? Text(
                    "Deleted by moderator") // If a comment has been deleted by moderator
                : Text(item.by), // Otherwise display comment
            // Controlls depth render
            contentPadding: EdgeInsets.only(
              right: 16.0,
              // Included current depth plus default value of 1 multiplied by 16.0
              left: (depth + 1) * 16.0,
            ),
          ),
          Divider(),
        ];

        // Iterate over the list of kids, add a new record
        snapshot.data.kids.forEach((kidId) {
          children.add(
            // Pass in kidId and itemMap repeatedly
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1, // Iterate up based on depth of comments
            ),
          );
        });

        // Render children
        return Column(children: children);
      },
    );
  }

  // Helper method to clean up text. This is a partial clean up but can be expanded to make it perfect.
  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', " ' ")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');

    return Text(text);
  }
}
