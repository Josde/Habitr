import 'dart:async';
import 'dart:io';

Future<List<FileSystemEntity>> dirContents(Directory dir) async {
  final List<FileSystemEntity> entities = await dir.list().toList();
  return entities;
}