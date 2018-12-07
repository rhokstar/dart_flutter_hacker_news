// Test for values being returned from API from two functions in NewsApiProvider class.

// Testing utils
import 'dart:convert';
import 'package:test_api/test_api.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

// Instead of using an absolute or relative URL that's outside lib folder, use package + project name
import 'package:flutter_news/src/resources/news_api_provider.dart';

void main() {
  // Create MockClient for HTTP request instead of a live API
  // First test: FetchTopIds
  test('FetchTopIds returns a list of ids', () async {
    final newsApi = NewsAPIProvider();

    // Replace the client in newsApi Provider
    newsApi.client = MockClient((request) async {
      // Return some JSON data. This requires a Future that contains a response with specific requirements, thus a Response object, like response code 200 (success).
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    // Get a list of top ids. Simulate a wait.
    final ids = await newsApi.fetchTopIds();

    expect(ids, [1, 2, 3, 4]);
  });

  // Second test: FetchItem
  test('FetchItem returns a ItemModel', () async {
    final newsApi = NewsAPIProvider();
    newsApi.client = MockClient((request) async {
      // The single item fetch ID
      final jsonMap = {'id': 123};

      // Represents a single object by ID
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(999);

    expect(item.id, 123);
  });
}