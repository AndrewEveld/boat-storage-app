import 'dart:io';

import 'package:boat_storage_app/point_list.dart';
import 'package:boat_storage_app/save_load.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'storage_point.dart';

// Image uploading inspired by https://www.coderzheaven.com/2019/01/08/flutter-tutorial-select-an-image-from-gallery-and-show-in-imageview/



class EditPointsView extends StatefulWidget {
  EditPointsView({Key key, this.title, this.storage}) : super(key: key);

  final String title;
  final SaveLoad storage;

  @override
  _EditPointsState createState() => new _EditPointsState();
}

class _EditPointsState extends State<EditPointsView> {
  File imageFile;
  final _picker = ImagePicker();
  List<StoragePoint> storagePointsList;
  int gridWidth = 10;
  int gridHeight;
  int _currentEditIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readData().then((List<StoragePoint> value) {
      widget.storage.getImage().then((File loadedImage) {
        setState(() {
          storagePointsList = value;
          imageFile = loadedImage;
          int lockEdit = widget.storage.lockEdit;
          _currentEditIndex = lockEdit == null ? 0 : lockEdit;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    //print(saveLoad.pointListToJson(storagePointsList));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = (screenSize.height - kToolbarHeight - 24);
    double screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Points"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Save your Boat",
            onPressed: () {widget.storage.save(imageFile, storagePointsList, _currentEditIndex);},
          ),
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            tooltip: "Add a different photo",
            onPressed: isEditable() ? pickImageFromGallery : null,
          ),
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Help!',
            onPressed: () {infoAlert();},
            ),
          ],
      ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.lock_open),
          title: Text('Unlock Edit'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lock),
          title: Text('Lock Edit'),
        ),
      ],
      onTap: onEditChange,
      currentIndex: _currentEditIndex,
    ),
      body: Stack(
        children: <Widget>[
          getImageWidget(screenWidth, screenHeight),
          createGridListWidget(screenSize),
        ],
      )
    );
  }

  void onEditChange(int index) {
    if (index != _currentEditIndex) {
      setState(() {
        _currentEditIndex = index;
      });
    }
  }

  Widget createGridListWidget(Size screenSize) {
    return GridView.count(
      padding: EdgeInsets.all(0.0),
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: gridWidth,
      childAspectRatio: getChildAspectRatio(screenSize),
      children: createGridList(),
      controller: ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }

  double getChildAspectRatio(Size screenSize) {
    double screenHeight = (screenSize.height - kToolbarHeight - 50);
    double screenWidth = screenSize.width;
    double lengthToWidthRatio = screenHeight / screenWidth;
    gridHeight = (gridWidth * lengthToWidthRatio) ~/ 1;
    return (screenWidth / gridWidth) / (screenHeight / gridHeight);
  }

  List<Widget> createGridList() {
    List<Widget> emptyGridList = List();
    print(gridHeight);
    for (int i = 0; i < gridHeight; i++) {
      for (int j = 0; j < gridWidth; j++) {
        if (isEdgePoint(i, j))
          emptyGridList.add(Container());
        if (i == gridHeight - 3 && j == gridWidth - 1 && isEditable()) {
          emptyGridList.add(getTrashWidget());
        }
        else
          isEditable() ? emptyGridList.add(getEmptyGridDragTarget(j, i)) :
            emptyGridList.add(emptyGridContainer());
      }
    }
    for (int i = 0; i < gridWidth * 2; i++) {
      emptyGridList.add(Container());
    }
    if (storagePointsList != null) replaceEmptyGridWithStoragePoints(emptyGridList);
    return emptyGridList;
  }

  Widget getTrashWidget() {
    return DragTarget (
      builder: (context, List<int> candidateData, rejectedData) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delete_forever));
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        setState(() {
          storagePointsList.removeAt(data);
        });
      },
    );
  }

  List<StoragePoint> getStoragePointsList() {
    return storagePointsList;
  }

  Widget getEmptyGridDragTarget(int x, int y) {
    return DragTarget(
      builder: (context, List<int> candidateData, rejectedData) {
        return editableEmptyGridContainer(x, y);
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        movePointOnGrid(data, x, y);
      },
    );
  }

  Widget editableEmptyGridContainer(int xPoint, yPoint) {
      return GestureDetector(
        onTap: () {addStoragePoint(xPoint, yPoint);},
        child: emptyGridContainer(),
      );
  }
  
  Widget emptyGridContainer() {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.all(0.0),
      child: Center(),
    );
  }

  Widget draggablePoint(int indexOfPoint) {
    return GestureDetector(
      child: Draggable(
        child: visiblePoint(),
        feedback: visiblePoint(),
        childWhenDragging: Container(),
        data: indexOfPoint,
      ),
      onTap: () {openPointList(storagePointsList.elementAt(indexOfPoint));},
    );
  }

  Widget staticGridPoint(int indexOfPoint) {
    return GestureDetector(
      child: visiblePoint(),
      onTap: () {openPointList(storagePointsList.elementAt(indexOfPoint));},
    );
  }
  
  Widget visiblePoint() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(width: 5.0, color: Colors.blue),
      ),
      height: 50.0,
      width: 50.0,
    );
  }

  bool isEdgePoint(int x, int y) {
    bool onTopOrBottom = x >= gridHeight - 2;
    return onTopOrBottom;
  }

  void addStoragePoint(int x, int y) {
    setState(() {
      storagePointsList.add(StoragePoint(x, y));
    });
  }

  void replaceEmptyGridWithStoragePoints(List<Widget> gridList) {
    for (int i = 0; i < storagePointsList.length; i++) {
      StoragePoint point = storagePointsList.elementAt(i);
      int listPosition = point.getX() + gridWidth * point.getY();
      gridList.removeAt(listPosition);
      if (isEditable()) gridList.insert(listPosition, draggablePoint(i));
      else gridList.insert(listPosition, staticGridPoint(i));
      print("point added");
    }
  }

  void movePointOnGrid(int indexOfMovingPoint, int xTarget, int yTarget){
    setState(() {
      print("package dropped");
      getStoragePointsList().elementAt(indexOfMovingPoint).setLocation(xTarget, yTarget);
    });
  }

  void pickImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile.path);
    });

  }

  Widget getImageWidget(double screenWidth, double screenHeight) {
    return imageFile != null ? Image.file(
      imageFile,
      fit: BoxFit.fill,
      width: screenWidth,
      height: screenHeight,
    ) : Text("No image chosen");
  }

  void openPointList(StoragePoint pointPressed) {
    showDialog(
        context: context,
        builder: (context) {return PointList(storagePoint: pointPressed, isEditable: isEditable());});
  }

  // Taken from https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter
  infoAlert() {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Help!"),
      content: Text("Tap while Edit is unlocked to create points! Drag the "
          "points to move them! Press the Save icon to save your progress! Press"
          " the image icon to add an image! Drag points to the trash to delete! "
          "Press Lock Edit to prevent changes."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool isEditable() {
    return _currentEditIndex == 0;
  }
}
