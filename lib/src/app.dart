import 'package:flutter/material.dart';
import './screens/news_list.dart';
import 'blocs/stories_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    // Create new instance of StoriesProvider, wrap MaterialApp to make available into the whole app
    return StoriesProvider(
      child: MaterialApp(
        title: 'HackerNews',
        home: NewsList(),
      ),
    );
  }
}
