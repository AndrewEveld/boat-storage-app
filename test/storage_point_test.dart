import 'package:flutter_test/flutter_test.dart';
import 'package:boat_storage_app/storage_point.dart';

void main() {
  test("Create Storage Point", () {
    int xPosition = 0;
    int yPosition = 0;
    StoragePoint newStoragePoint;
    newStoragePoint = StoragePoint(xPosition, yPosition);
    expect(0, newStoragePoint.getX());
    expect(0, newStoragePoint.getY());
  });

  test("Add to Storage Point List", () {
    String toAddToPoint = "toAdd";
    StoragePoint storagePoint = StoragePoint(0, 0);
    storagePoint.addToList(toAddToPoint);
    List<String> returnedList = storagePoint.getStorageList();
    expect(1, returnedList.length);
    expect("toAdd", returnedList.elementAt(0));
  });

  test("Remove From List Return Empty String When Index Out Of Range", () {
    StoragePoint storagePoint = StoragePoint(0, 0);
    String addToPoint = "toAdd";
    storagePoint.addToList(addToPoint);
    expect("", storagePoint.removeFromList(1));
  });

  test("Move Storage Point Should Work", () {
    StoragePoint fromPoint = StoragePoint(0, 0);
    StoragePoint toPoint = StoragePoint(0, 0);
    String itemToMove = "itemToMove";
    fromPoint.addToList(itemToMove);
    fromPoint.moveItemToStoragePoint(toPoint, 0);
    List<String> toPointList = toPoint.getStorageList();
    expect(1, toPointList.length);
    expect("itemToMove", toPointList.elementAt(0));
    expect(0, fromPoint.getStorageList().length);
  });
}