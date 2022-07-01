import 'dart:async';

import 'package:mysql1/mysql1.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SqlAuth {

  static Future<MySqlConnection> connectDB() async {
    // Open a connection
    final MySqlConnection conn = await MySqlConnection.connect(ConnectionSettings(
        host: '192.168.0.105',
        //port: 3306,
        user: 'root',
        db: 'bisnisku',
        password: ''));
    return conn;
  }

  static disconnectDB({required MySqlConnection conn}) async {
    if (conn == true) {
      await conn.close();
    };
  }

  ///// DB QUERY CRUD

  Future<MySqlConnection?> createTable({
    required MySqlConnection conn,
    required String tableName
  }) async {

    // Create a table
    await conn.query('CREATE TABLE ' + tableName); // QUERY COLUMNS >> + '('+ columns.values[0].toString() +')');

  }

  Future<MySqlConnection?> addColumnsTable({
    required MySqlConnection conn,
    required String tableName,
    required Map<String, String> columns // key: column names, val: data tipe
  }) async {

    // alter the table
    columns.forEach((key, val) async {
      await conn.query('ALTER TABLE ' + tableName + ' ADD ' + key + ' ' + val); // QUERY COLUMNS >> + '('+ columns.values[0].toString() +')');
    });
  }

  Future<MySqlConnection?> addColumnTable({
    required MySqlConnection conn,
    required String tableName,
    required String columnName,
    required String columnType
  }) async {

    // alter the table
    await conn.query('ALTER TABLE ' + tableName + ' ADD ' + columnName + ' ' + columnType); // QUERY COLUMNS >> + '('+ columns.values[0].toString() +')');

  }

  Future<MySqlConnection?> deleteColumnTable({
    required MySqlConnection conn,
    required String tableName,
    required String columnName
  }) async {

    // alter the table
    await conn.query('ALTER TABLE ' + tableName + ' DROP COLUMN ' + columnName); // QUERY COLUMNS >> + '('+ columns.values[0].toString() +')');

  }

  Future<MySqlConnection?> deleteTable({
    required MySqlConnection conn,
    required String tableName,
    required Map<String, dynamic> columns
  }) async {

    // Create a table
    await conn.query('DROP TABLE ' + tableName); // QUERY COLUMNS >> + '('+ columns.values[0].toString() +')');

  }

  Future<MySqlConnection?> insertTable({
    required MySqlConnection conn,
    required String tableName,
    required Map<String, dynamic> columns
  }) async {

    // Create a table
    await conn.query('DROP TABLE ' + tableName); // QUERY COLUMNS >> + '('+ columns.values[0].toString() +')');

  }

  Future<MySqlConnection?> insertIntoTable({
    required MySqlConnection conn,
    required String tableName,
    required Map<String, String> covals
  }) async {

    // insert into a table
    covals.forEach((key, value) {
      conn.query('INSERT INTO ' + tableName); // QUERY COLUMNS >> + '('+ columns.values[0].toString() +')');
    });

  }



}
