import 'package:flutter/material.dart';
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
                Text(""),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPointsView()),
                    );
                  },
                    color: Colors.blue,
                    child: Text(
                        "New Boat",
                        style: new TextStyle(fontSize: 40.0, color: Colors.white),
                      ),
                    ),
                Container(height: 40.0),
                RaisedButton(
                      onPressed: () => {},
                      color: Colors.blue,
                      child: Text(
                          "Old Boat",
                          style: new TextStyle(fontSize: 40.0, color: Colors.white),
                      )
                  ),
                Container(height: 40.0),
              ],
            )]
        )

      ),
    );
  }
}