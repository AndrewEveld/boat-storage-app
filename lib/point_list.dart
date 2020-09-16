import 'package:boat_storage_app/storage_point.dart';
import 'package:flutter/material.dart';

// inspired by https://stackoverflow.com/questions/50095763/flutter-listview-in-a-simpledialog

class PointList extends StatefulWidget {
  const PointList({Key key, this.storagePoint, this.isEditable}) : super(key: key);

  final StoragePoint storagePoint;
  final bool isEditable;

  @override
  _PointListState createState() => new _PointListState(storagePoint);
}

class _PointListState extends State<PointList>{
  StoragePoint storagePoint;
  
  _PointListState(StoragePoint currentPoint) {
    storagePoint = currentPoint;
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView(
              padding: const EdgeInsets.all(8),
            children: getWidgetListOfItems(),
          ),
        ),
      );
   }
   
   List<Widget> getWidgetListOfItems() {
    List<String> itemList = storagePoint.getStorageList();
    List<Widget> widgetListOfItems = List();
    for (String itemName in itemList) {
      widgetListOfItems.add(getListItem(itemName));
      widgetListOfItems.add(Container(height: 10,));
    }
    if (widget.isEditable) widgetListOfItems.add(getInputWidget());
    return widgetListOfItems;
  }
   
   Widget getListItem(String itemName) {
    return Text(itemName);
   }
   
   Widget getInputWidget() {
     return TextField(
       decoration: InputDecoration(
         border: OutlineInputBorder(),
         labelText: 'Add New Item',
       ),
       onSubmitted: (itemToAdd) {addItemToList(itemToAdd);},
     );
   }

   void addItemToList(String itemToAdd) {
    setState(() {
      storagePoint.addToList(itemToAdd);
    });
   }
}