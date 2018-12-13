import 'package:flutter/material.dart';
import './screens/news_list.dart';
import './screens/news_detail.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    // Create new instance of CommentsProvider and StoriesProvider, wrap MaterialApp to make available into the whole app
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'HackerNews',
          // Generate Navigation
          // Helper Methods
          onGenerateRoute: routes,
        ),
      ),
    );
  }
  // Helper Methods

  // Settings contains itemsID
  Route routes(RouteSettings settings) {
    // Decides what to show
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          // Give widget access to storiesBloc
          final bloc = StoriesProvider.of(context);
          // Get top stories
          bloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          // Get access to comments bloc
          final commentsBloc = CommentsProvider.of(context);
          
          // Extract itemId from settings.name and pass into NewsDetail
          final itemId =
              int.parse(settings.name.replaceFirst('/', '')); // Removes the slash

          // Do initial fetch of itemId for each story
          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(
            // Named parameter
            itemId: itemId,
        );
      });
    }
  }
}
