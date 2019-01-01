import 'package:audiobooks/resources/models/book.dart';
import 'package:audiobooks/resources/repository.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:webfeed/webfeed.dart';

final _root = "https://librivox.org/api/";
final _books = _root + "feed/audiobooks";

class BooksApiProvider implements Source{

  Client client = Client();
  Future<List<Book>> fetchBooks(int offset, int limit) async {
    final response = await client.get("$_books?format=json&extended=1&offset=$offset&limit=$limit");
    Map books = json.decode(response.body);
    List<Map> boo = List<Map>();
    books["books"].forEach((String key, dynamic value)=>boo.add(value));
    return Book.fromJsonArray(boo);
  }

  Future<List<RssItem>> fetchFeeds(String url) async {
    if(url == null) return null;
    final response = await client.get(url);
    final String feed = response.body;
    RssFeed rssFeed = RssFeed.parse(feed);
    return rssFeed.items;
  }

}

final booksApiProvider = BooksApiProvider();