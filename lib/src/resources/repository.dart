// Repository AFTER refactor example.

// Repository governs the access of the API and DB providers.

import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  // Create instance variable for list of source objects
  // Add any other data sources here
  List<Source> sources = <Source>[
    newsDBProvider, // make use of existing DB connection
    NewsAPIProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDBProvider // make use of existing DB connection
  ];

  // Get top HN articles
  // * Annotate your return types *
  // ToDo: Iterate over sources when dbprovider gets fetchTopids
  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  // Get specific HN items
  Future<ItemModel> fetchItem(int id) async {
    // For loop to iterate through list of sources...
    ItemModel item;
    Source source;

    for (source in sources) {
      // Check item for null or ItemModel
      item = await source.fetchItem(id);
      // Stop value is null
      if (item != null) {
        break;
      }
    }


    for (var cache in caches) {
      cache.addItem(item);
    }

    return item;
  }
}

//
abstract class Source {
  // Qualifiers
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

//
abstract class Cache {
  // Because sqflite is typed Future<int>, annotate here too
  Future<int> addItem(ItemModel item);
}
