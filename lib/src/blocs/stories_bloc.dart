// Manages top stories
import 'dart:async';
import '../models/item_model.dart';
import '../resources/repository.dart';

// Rx Dart to combine streams
import 'package:rxdart/rxdart.dart';

class StoriesBloc {
  // Make repository available for fetchTopIds
  final _repository = Repository();

  // PublishSubject is the equivalent of a StreamController
  // Private variable to the getter is used instead
  // _topIds Generic class typed as List int
  // Add repository into StreamController
  final _topIds = PublishSubject<List<int>>();

  // SteamController equivalent in RxDart. All widgets listen to this stream for most recent events data.
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Items fetcher, all integers go here
  final _itemsFetcher = PublishSubject<int>();

  // Getter to streams
  // Observables are streams (reminder)
  // Make repository available to the outside through the use if this getter
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getter to Sinks
  // Adds to sink only one time
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  // Constructor function is invoked
  StoriesBloc() {
    // Takes output event of stream to a target destination. Joins all pieces of the data stream.
    // ItemsFetcher => Transformer => ItemsOuput
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  // The repository adds to the sink (as compared to a widget add information from a user)
  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    // add to sink
    _topIds.sink.add(ids);
  }

  //  Takes ID, fetches appropriate item
  _itemsTransformer() {
    return ScanStreamTransformer(
      // Invoke function when new data event comes in
      // Adds ID into cache
      (Map<int, Future<ItemModel>> cache, int id, index) {
        print(index);
        // Establish new key in the map and assign Future with ItemModel
        cache[id] = _repository.fetchItem(id);
        // Return newly updated cache map
        return cache;
      },
      // Starting value
      <int, Future<ItemModel>>{},
    );
  }

  // Clean up the StreamControllers by using dispose.
  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}