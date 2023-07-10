// import 'dart:convert';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'cache_manager.dart';

// class DatabaseHandler {
//   final String cacheKey = 'books_data';

//   Future<dynamic> fetchAyahBounds() async {
//     final cache = CacheManager(cacheKey);
//     // First, try to fetch the data from cache
//     var cachedData = await cache.fetchData(cacheKey);
//     if (cachedData != null) {
//       return cachedData;
//     }

//     // Data is not cached or expired, fetch it from the database
//     final dbPath = await getApplicationDocumentsDirectory();
//     final db = await openDatabase(dbPath.path);

//     // Fetch the books data from the database
//     final results = await db.query('books');

//     // Close the database connection
//     await db.close();

//     // Convert books data to JSON
//     final json = jsonEncode(books);

//     // Cache the data
//     cache.putFile(cacheKey, utf8.encode(json));

//     return books;
//   }
// }
