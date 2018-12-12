import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart';

// Find the nearest CommentsProvider
class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  // Constructor Method
  CommentsProvider({Key key, Widget child})
      // Initialize bloc
      : bloc = CommentsBloc(),
        // Super constructor
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  // Returns CommentsBloc
  static CommentsBloc of(BuildContext context) {
    // Find the nearest CommentsProvider and treat it as a CommentsProvider
    return (context.inheritFromWidgetOfExactType(CommentsProvider)
            as CommentsProvider)
        // Return the bloc property
        .bloc;
  }
}
