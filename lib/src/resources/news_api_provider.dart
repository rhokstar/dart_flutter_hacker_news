// Enables get requests and testing
// Only show Client class
import 'package:http/http.dart' show Client;

// Enabled JSON decoding
import 'dart:convert';

// ItemModel
import '../models/item_model.dart';

// Keep the root private. Note: no trailing slash at the end.
final _root = 'https://hacker-news.firebaseio.com/v0';

// Reaches out to API and it's to endpoints
class NewsAPIProvider {
  // Create instance of Client class
  Client client = Client();

  // Get Top articles from HN API
  // Don't foget async and await go together
  fetchTopIds() async {
    // Wait for the request to be completed and assign to a variable
    final response = await client.get('$_root/topstories.json');
    
    // Decode JSON response body
    // jsonDecode or json.decode are the same
    final ids = jsonDecode(response.body);

    // Return the list of ids
    return ids;
  }

  // Get specific article by a single ID
  fetchItem(int id) async {
    // String interpolation $id
    final response = await client.get('$_root/item/$id.json');

    // Parse respnse
    final parsedJson = jsonDecode(response.body);

    // Return ItemModel with parsedJson using fromJSON
    return ItemModel.fromJson(parsedJson);
  }
}