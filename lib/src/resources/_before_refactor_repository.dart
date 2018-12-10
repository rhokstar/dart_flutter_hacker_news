// Repository BEFORE refactor example.

// Repository governs the access of the API and DB providers.

import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  // Create instance variables of DB and API providers. NewsDBProvider needs to init.
  NewsDBProvider dbProvider = NewsDBProvider();
  NewsAPIProvider apiProvider = NewsAPIProvider();

  // Get top HN articles
  // *Annotate your return types*
  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIds();
  }

  // Get specific HN items
  Future<ItemModel> fetchItem(int id) async {
    // Check to see if specific itemModel exists or null
    // Using 'var' just incase it needs to be reassigned instead of using 'final'
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    // Receive item from API. Gaurantees an item unless network error. Need to wait for this.
    item = await apiProvider.fetchItem(id);
    // Add to DB. No need to use 'await'
    dbProvider.addItem(item);

    return item;
  }
}
