import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class CommentsBloc {
  // Instance Variables
  final _repository = Repository();

  // Items fetcher, all integers go here
  final _commentsFetcher = PublishSubject<int>();

  // SteamController equivalent in RxDart. All widgets listen to this stream for most recent events data.
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Getters
  // Read the Streams
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sinks
  // Fetch a story with all the data and then fetch a limited list of comments
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  // Contructor
  // Takes output event of stream to a target destination. Joins all pieces of the data stream.
  // _commentsFetcher => _commentsTransformer => _commentsOuput
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  // **** Recursive Data Fetching ****
  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      // Story ID comes in
      (cache, int id, index) {
        print(index);
        // Get the Story ID. Returns a Future<ItemModel> that will resolve into cache map: cache[id]
        cache[id] = _repository.fetchItem(id);
        // Reference the cache map: cache[id]. '.then' is chained on... (like JavaScript)
        cache[id].then((ItemModel item){
          // Invokes this inner function whenever the Future ItemModel gets received by the Repository.
          // For each of those kidId's, pass them back into fetchItemWithComments getter (aka _commentsFetcher)
          // Pass back the kidId to sink. The sink then sends kidId back to _commentsTransformer and repeats the process.
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });
        return cache;
      },
      // Starting Value
      <int, Future<ItemModel>>{}
    );
  }

  // Clean up the StreamControllers by using dispose.
  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
