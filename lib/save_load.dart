import 'dart:convert';
import 'dart:io';
import 'package:boat_storage_app/storage_point.dart';
import 'package:path_provider/path_provider.dart';

// Taken from Flutter API Doc https://flutter.dev/docs/cookbook/persistence/reading-writing-files

class SaveLoad {
  String filename = 'save_file.json';
  String imageName;
  int lockEdit;

  save(File imageFile, List<StoragePoint> pointList, int lockEdit) {
    print("saving...");
    this.lockEdit = lockEdit;
    imageName = imageFile.path.split("/").last;
    saveImage(imageFile).then((File imageName) {
      writeJsonToFile(pointList);
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<File> get _localImage async {
    final path = await _localPath;
    return File('$path/$imageName');
  }

  Future<File> writeJsonToFile(List<StoragePoint> pointList) async {
    print("writing");
    final file = await _localFile;
    print("writing" + pointListToJson(pointList));
    return file.writeAsString(pointListToJson(pointList));
  }

  Future<List<StoragePoint>> readData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return parseJson(contents);
    }
    catch (e) {
      return List();
    }
  }

  Future<File> saveImage(File imageFile) async {
    final file = await _localImage;
    return imageFile.rename(file.path);
  }

  Future<File> getImage() async {
    try {
      final file = await _localImage;
      return file;
    }
    catch (e) {
      return File('assets/nothing.png');
    }
  }

  List<StoragePoint> parseJson(String contents) {
    Map<String, dynamic> decoded = jsonDecode(contents);
    imageName = decoded['image'];
    lockEdit = decoded['lockEdit'];
    print(imageName);
    List<dynamic> listOfPointsJson = decoded["points"];
    print(listOfPointsJson);
    List<StoragePoint> listToReturn = List();
    for (Map<String, dynamic> map in listOfPointsJson) {
      int x = map['x'];
      int y = map['y'];
      StoragePoint toAddPoint = StoragePoint(x, y);
      List<dynamic> itemList = map["items"];
      for (Map<String, dynamic> itemName in itemList) {
        String name = itemName['name'];
        if (name != null) toAddPoint.addToList(name);
      }
      listToReturn.add(toAddPoint);
    }
    return listToReturn;

  }

  String pointListToJson(List<StoragePoint> pointList) {
    print("Points!");
    String jSonToReturn = '{"points" : [';
    for (StoragePoint point in pointList) {
      jSonToReturn += pointToJson(point);
    }
    if (pointList.isEmpty) {jSonToReturn += '{},';}
    jSonToReturn = jSonToReturn.substring(0, jSonToReturn.length - 1);
    jSonToReturn += '], "image" : "' + imageName + '", "lockEdit" : ' + lockEdit.toString() + '}';
    return jSonToReturn;
  }

  String pointToJson(StoragePoint point) {
    String jSonToReturn = '{"items" : [';
    for (String item in point.getStorageList()) {
      jSonToReturn += '{"name":"' + item + '"},';
    }
    if (point.getStorageList().isEmpty) {jSonToReturn += "{},";}
    jSonToReturn = jSonToReturn.substring(0, jSonToReturn.length - 1);
    jSonToReturn += '],';
    jSonToReturn += '"x":' + point.getX().toString() + ',';
    jSonToReturn += '"y":' + point.getY().toString() + '},';
    return jSonToReturn;
  }


}

