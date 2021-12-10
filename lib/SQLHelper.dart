import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nomor_induk TEXT,   
        nama TEXT,     
        alamat TEXT,
        ttl TEXT,
        ttl_cuti TEXT,     
        lama_cuti TEXT,
        ket_cuti TEXT,
        cuti TEXT,  
        date TEXT,  
        sisa TEXT,  
        tempGabung TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'mceasy',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String nomor_induk, String? nama, String? alamat, String? ttl,
      String ttl_cuti, String? lama_cuti, String? ket_cuti,String? cuti,String? date, String? sisa, String? tempGabung) async {
    final db = await SQLHelper.db();
    final data = {'nomor_induk': nomor_induk,'nama': nama,'alamat': alamat, 'ttl': ttl,
      'ttl_cuti': ttl_cuti, 'lama_cuti': lama_cuti,'ket_cuti': ket_cuti, 'cuti': cuti,'date': date, 'sisa': sisa,'tempGabung': tempGabung};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String nomor_induk, String? nama, String? alamat, String? ttl,
      String ttl_cuti, String? lama_cuti, String? ket_cuti,String? cuti, String? date, String? sisa, String? tempGabung) async {
    final db = await SQLHelper.db();
    final data = {
      'nomor_induk': nomor_induk,
      'nama': nama,
      'alamat': alamat,
      'ttl': ttl,
      'ttl_cuti': ttl_cuti,
      'lama_cuti': lama_cuti,
      'ket_cuti': ket_cuti,
      'date': date,
      'cuti': cuti,
      'sisa': sisa,
      'tempGabung': tempGabung,
      'createdAt' : DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}