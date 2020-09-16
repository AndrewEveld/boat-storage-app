import 'package:boat_storage_app/save_load.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'edit_points_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Boat Storage App',
    home: StartScreen(),
  ));
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Boat Storage", style: new TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(width: 150, child: Icon(Icons.directions_boat, size: 150,)),
                Container(height: 40.0,),
                infoText("Welcome to the Boat Storage App!"),
                infoText("Click below to upload your boat plans or edit your existing boat plans!"),
                infoText("(Portrait orientation recommended)"),
                Container(height: 40.0),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPointsView(storage: SaveLoad(),)),
                    );
                  },
                    color: Colors.blue,
                    child: Text(
                        "View Boat",
                        style: new TextStyle(fontSize: 40.0, color: Colors.white),
                      ),
                    ),
                Container(height: 40.0),
              ],
            )]
        )

      ),
    );
  }

  Widget infoText(String text) {
    return Container(
      child: Text(
        text,
        style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      width: 300,
    );
  }
}