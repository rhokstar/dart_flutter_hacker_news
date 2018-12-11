// Enables get requests and testing
// Only show Client class
import 'package:http/http.dart' show Client;

// Enabled JSON decoding
import 'dart:convert';

// ItemModel
import '../models/item_model.dart';

// Wiring up abstract class Source
import './repository.dart';

import 'dart:async';

// Keep the root private. Note: no trailing slash at the end.
final _root = 'https://hacker-news.firebaseio.com/v0';

// Reaches out to API and it's to endpoints
// Abstract class Source gets implemented here
class NewsAPIProvider implements Source{
  // Create instance of Client class
  Client client = Client();

  // Get Top articles from HN API
  // Don't foget async and await go together
  // ** Also, don't forget to annotate types! **
  // Anytime async is involved, there's an intermediate return value that takes data and wraps it inside a Future.
  Future<List<int>> fetchTopIds() async { // Annotate Future and List int
    // Wait for the request to be completed and assign to a variable
    final response = await client.get('$_root/topstories.json');
    
    // Decode JSON response body
    // jsonDecode or json.decode are the same
    
    final ids = jsonDecode(response.body);

    // Return the list of ids
    // ** Using cast to let Dart know that we're receiving integers because of the jsonDecide(response.body) ** If 'cast' is not there, it will fail the test.
    return ids.cast<int>();
  }

  // Get specific article by a single ID
  Future<ItemModel> fetchItem(int id) async {
    // String interpolation $id
    final response = await client.get('$_root/item/$id.json');

    // Parse respnse
    final parsedJson = jsonDecode(response.body);

    // Return ItemModel with parsedJson using fromJSON
    return ItemModel.fromJson(parsedJson);
  }
}