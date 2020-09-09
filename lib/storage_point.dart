import 'package:flutter/material.dart';

class StoragePoint {
  Coordinates _pointPosition;
  List<String> _storageList;


  StoragePoint(int x, int y) {
    _pointPosition = Coordinates(x, y);
    _storageList = List();
  }

  int getX() {
    return _pointPosition.x;
  }

  int getY() {
    return _pointPosition.y;
  }

  List<String> getStorageList() {
    return _storageList;
  }

  void addToList(String item) {
    _storageList.add(item);
  }

  String removeFromList(int index) {
    if (index < _storageList.length) {
      String itemName = _storageList.elementAt(index);
      _storageList.removeAt(index);
      return itemName;
    }
    return "";

  }

  void moveItemToStoragePoint(StoragePoint destination, int index) {
    String itemToMove = removeFromList(index);
    if (itemToMove != "") {
      destination.addToList(itemToMove);
    }
  }
}

class Coordinates {
  int x;
  int y;

  Coordinates(int x, int y) {
    this.x = x;
    this.y = y;
  }
}