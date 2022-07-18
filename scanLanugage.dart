import 'dart:async';
import 'dart:io';

class ScanLanguage {
  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: true, followLinks: true);
    lister.listen((file) {
      RegExp regExp = new RegExp("\.dart", caseSensitive: false);
      if (regExp.hasMatch('$file')) {
        files.add(file);
      }
    }, cancelOnError: true, onDone: () => completer.complete(files));
    return completer.future;
  }

  Future<List<File>> entitiesToFiles(String path) async {
    ///[Path] is the diractory path you wish to scan
    Directory? dir;
    try {
       dir = Directory(path);
    } catch (e) {
      throw Exception(path +" doesnt exist");
      exit(1);
    }
    final entities = await this.dirContents(dir);

    return entities.map((entity) {
      return (File(entity.uri.path));
    }).toList();
  }

  Future<Map<String, String>> captureMatches(String stringToCapture) async {
    final regex =
        RegExp(r'''(?:translate\("([^"]*)"\)|translate\('([^']*)'\))''');

    final matches = regex.allMatches(stringToCapture);
    final strings = matches.map(((e) {
      return e[1] ?? e[2];
    }));
    Map<String, String> filteredMatches = {};
    for (var string in strings) {
      filteredMatches[string ?? ""] = string ?? "";
    }
    return filteredMatches;
  }
}
