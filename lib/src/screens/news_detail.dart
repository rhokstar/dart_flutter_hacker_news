import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../blocs/comments_provider.dart';

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
              if(!snapshot.hasData) {
                return Text('Loading');
              }

              // Will resolve an itemId
              final itemFuture = snapshot.data[itemId];

              return FutureBuilder(
                future: itemFuture,
                builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
                  // Check for snapshot data
                  if(!itemSnapshot.hasData) {
                    return Text('Loading');
                  }

                  // Return item title
                  // Helper Method
                  return buildTitle(itemSnapshot.data);
                },
              );
            });
  }

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
