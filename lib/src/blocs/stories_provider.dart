// Makes stories bloc available in the widget tree
// Provider code tends to be very similar.

import 'package:flutter/material.dart';
import './stories_bloc.dart';

// Make available without having to repetively import
export './stories_bloc.dart';

// Whenever InheritedWidget is extended, 'updateShouldNotify' is required
// Define Provider's construction function and pass to base class of InheritedWidget
class StoriesProvider extends InheritedWidget {
  // Create instance of Bloc
  final StoriesBloc bloc;

  // Define two named args
  StoriesProvider({Key key, Widget child})
      // Use constructor to create new instance of story bloc
      : bloc = StoriesBloc(),
        // Pass args to InheritedWidget
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  // Static: Not necessary to create an instance of Bloc to provide access to the function
  // 'of' links Bloc to Context, makes available to the widget heirarchy
  static StoriesBloc of(BuildContext context) {
    // Look higher in the build heirarchy that looks like Provider, 'as' helps Dart understand the value that comes back.
    return (context.inheritFromWidgetOfExactType(StoriesProvider)
            as StoriesProvider)
        .bloc;
  }
}
