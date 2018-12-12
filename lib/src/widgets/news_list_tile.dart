import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import '../widgets/loading_container.dart';

class NewsListTile extends StatelessWidget {
  // Needs to know what ID to look for
  // Create an instance variable that will passed in from the parent as a contructor arg
  final int itemId;

  // Constructor arg and forward to itemId
  NewsListTile({this.itemId});

  // Build method
  Widget build(context) {
    // Stream builder gets connected to bloc
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      // Item Stream
      stream: bloc.items,
      // Receive Map
      // Annotate snapshot as AsyncSnapshot due to complex data types
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          // Check if data is loading
          return LoadingContainer();
        }

        // Look at map and find the relevant ID
        return FutureBuilder(
          // Find the ID
          future: snapshot.data[itemId],
          // Rename snapshot as itemSnapShot and annotate it
          builder: (context, AsyncSnapshot<ItemModel> itemSnapShot) {
            // Check if data is loading
            if (!itemSnapShot.hasData) {
              return LoadingContainer();
            }

            // If there's data, then output the article
            return buildTile(itemSnapShot.data);
          },
        );
      },
    );
  }

  // Helper Methods
  Widget buildTile(ItemModel item) {
    return Column(
      children: [
        ListTile(
          title: Text(item.title),
          subtitle:
              Text('${item.score} points'), // coerce to string interpolation
          trailing: Column(
            children: [Icon(Icons.comment), Text('${item.descendants}')],
          ),
        ),
        Divider(
          height: 8.0,
        )
      ],
    );
  }
}
