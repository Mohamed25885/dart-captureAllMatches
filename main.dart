import 'dart:convert';
import 'dart:io';

import 'scanLanugage.dart';

void main(List<String> args) async {
 final Map<String, String> jsonFile = {};
 ScanLanguage scan = ScanLanguage();
 final files = await scan.entitiesToFiles('path');
 for (var file in files) {
   final lines = await file.readAsLines();
   for (var line in lines) {
     final matches =  await scan.captureMatches(line);
     jsonFile.addAll(matches);
   }
 }
 await File("default.json").writeAsString(jsonEncode(jsonFile));
}
