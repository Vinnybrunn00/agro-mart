import 'dart:io';

void main() {
  final String path = '.';

  final Directory directory = Directory(path);

  directory.watch(recursive: true).listen((data) {

  });
}
