import 'package:flutter/material.dart';
import 'storage_point.dart';


class EditPointsView extends StatefulWidget {
  EditPointsView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EditPointsState createState() => new _EditPointsState();
}

class _EditPointsState extends State<EditPointsView> {
  List<StoragePoint> storagePointsList = List();
  List<bool> isStoragePoint = List();
  int gridWidth = 15;
  int gridLength = 30;
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final double itemHeight = (screenSize.height - kToolbarHeight - 24) / gridLength;
    final double itemWidth = screenSize.width / gridWidth;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Storage Points"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Storage Point',
            onPressed: () {},
            ),
          ],
      ),
      body: Container(
        child: GridView.count(
          padding: EdgeInsets.all(0.0),
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: gridWidth,
          childAspectRatio: (itemWidth / itemHeight),
          children: createGridList(),
          controller: ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  Widget emptyGridContainer(int x, int y) {
      return GestureDetector(
        onTap: () {addStoragePoint(x, y);},
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.all(0.0),
          child: Center(),
          ),
      );

  }

  Widget filledGridContainer() {
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(0.0),
        child: Center(
          child: Text("."),
        ),
      );
  }

  List<Widget> createGridList() {
    List<Widget> emptyGridList = List();
    for (int i = 0; i < gridLength; i++) {
      for (int j = 0; j < gridWidth; j++) {
        emptyGridList.add(emptyGridContainer(j, i));
      }
    }
    insertStoragePoints(emptyGridList);
    return emptyGridList;
  }

  void addStoragePoint(int x, int y) {
    setState(() {
      storagePointsList.add(StoragePoint(x, y));
    });
  }

  void insertStoragePoints(List<Widget> gridList) {
    for (StoragePoint point in storagePointsList) {
      int listPosition = point.getX() + gridWidth * point.getY();
      gridList.removeAt(listPosition);
      gridList.insert(listPosition, filledGridContainer());
      print("point added");
    }
  }

}
