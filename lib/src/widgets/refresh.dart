// Refresh the list view with new data.

import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  // Instance variable
  final Widget child;
  
  // Constructor
  Refresh({this.child});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      // Receive child
      child: child,
      // Return a Future and when this resolves, RefreshIndicator will go away.
      onRefresh: () async {
        // Reaches out to stories_bloc.dart => repository => DB provider to dump current cache
        await bloc.clearCache();
        // Communicate to Refresh method before the Refresh indicator goes away
        await bloc.fetchTopIds();
      },
    );
  }
}