import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:favouritelocation/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getdatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT )');
    },
    version: 1,
  );
  return db;
}

class Userplacesnotifier extends StateNotifier<List<Place>> {
  Userplacesnotifier() : super(const []);
  Future<void> loadplaces() async {
    final db = await getdatabase();
    final data = await db.query('user_places');
    final places = data
        .map((row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: Placelocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            )))
        .toList();
    state = places;
  }

  void addplaces(String title, File image, Placelocation location) async {
    final appdir = await syspaths.getApplicationCacheDirectory();
    final filename = path.basename(image.path);
    final copiedimage = await image.copy('${appdir.path}/$filename');
    final newplace =
        Place(title: title, image: copiedimage, location: location);
    final db = await getdatabase();

    db.insert('userplaces', {
      'id': newplace.id,
      'title': newplace.title,
      'image': newplace.image.path,
      'lat': newplace.location.latitude,
      'lng': newplace.location.longitude,
      'address': newplace.location.address,
    });
    state = [newplace, ...state];
  }
}

final Userplacesprovider =
    StateNotifierProvider<Userplacesnotifier, List<Place>>(
        (ref) => Userplacesnotifier());
