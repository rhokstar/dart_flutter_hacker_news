// Enables jsonDecode
import 'dart:convert';

// Parse JSON
// 1) Declare all fields
// 2) Assign types
// 3) Create constructors

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  // From API: Extract data from JSON
  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'] ?? false,
        type = parsedJson['type'],
        by = parsedJson['by'],
        time = parsedJson['time'],
        text = parsedJson['text'] ?? '', // If null, no text
        dead = parsedJson['dead'] ?? false, // If null, default to false
        parent = parsedJson['parent'],
        kids = parsedJson['kids'] ?? [], // If null, empty
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'] ?? 0; // If null, 0

  // From DB: Convert
  ItemModel.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        // Coerce to 0 or 1 to true or false
        deleted = parsedJson['deleted'] == 1,
        type = parsedJson['type'],
        by = parsedJson['by'],
        time = parsedJson['time'],
        text = parsedJson['text'],
        dead = parsedJson['dead'] == 1,
        parent = parsedJson['parent'],
        // Because this stores as a blob, turn into a String,
        kids = jsonDecode(parsedJson['kids']),
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'];

  // Convert to map for insertion to SQL DB
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "deleted": deleted ? 1 : 0,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      // Convert to true or false by 1 or 0 which SQL will store
      "dead": dead ? 1 : 0,
      "parent": parent,
      // Convert into JSON
      "kids": jsonEncode(kids),
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants
    };
  }
}
