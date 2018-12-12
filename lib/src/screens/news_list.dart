import 'package:flutter/material.dart';

// Also imports stories_bloc.dart (because of 'export') without having to import directly.
import '../blocs/stories_provider.dart';

import '../widgets/news_list_tile.dart';

import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    // Give widget access to bloc
    final bloc = StoriesProvider.of(context);

    // This is temporary. Bad!
    bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      // Render topIds to screen by helper methods
      body: buildList(bloc),
    );
  }

  // Helper methods
  Widget buildList(StoriesBloc bloc) {
    // Look at the stream in this block
    return StreamBuilder(
      // What we're looking for
      stream: bloc.topIds,
      // Define Type Annotation for snapshot or else it will throw an err
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        // If there's no data
        if (!snapshot.hasData) {
          // Center the CircularProgressIndicator
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Render the list

        // Refresh new data
        return Refresh(
          child: ListView.builder(
            // get list of ids
            itemCount: snapshot.data.length,
            // return list of ids and print out
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              // Render the data
              return NewsListTile(itemId: snapshot.data[index]);
            },
          ),
        );
      },
    );
  }
}
