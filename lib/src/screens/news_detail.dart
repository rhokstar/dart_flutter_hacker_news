import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../blocs/comments_provider.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  // Because this is statelesswidget, need to be final
  final int itemId;

  // Constructor
  NewsDetail({this.itemId});

  Widget build(context) {
    // Make bloc accessiblem which exposes the stream and cache map 'cache[id]'
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        // AppBar detects previous navigation and back button gets implemented automagically
        title: Text('Detail'),
      ),
      // Show the itemId
      body: buildBody(bloc),
    );
  }

  // Helper Method
  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
        // Watch the stream
        stream: bloc.itemWithComments,
        //
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
          // Check for snapshot data
          if (!snapshot.hasData) {
            return Text('Loading');
          }

          // Will resolve an itemId
          final itemFuture = snapshot.data[itemId];

          return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              // Check for snapshot data
              if (!itemSnapshot.hasData) {
                return Text('Loading');
              }

              // Helper Methods

              // Build the list. Pass in item model (itemSnapshot) and cache map (snapshot.data)
              return buildList(itemSnapshot.data, snapshot.data);
            },
          );
        });
  }

  // Helper methods

  // Build the list
  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    // Create an empty list of widgets to setup a merge of Title and kids
    final children = <Widget>[];

    // Add buildTitle
    children.add(buildTitle(item));

    // Look at the item model, look at the kids list, and map receives with kidId
    // When using '.map', it uses an Iterable which will then convert the map to a list.
    final commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 0,
      );
    }).toList();

    // Adds all children to the end of the commentsList which has an Iterable.
    // Merges Title and kids
    children.addAll(commentsList);

    // Returns the newly merged list
    return ListView(
      children: children,
    );
  }

  // Return item title
  Widget buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
