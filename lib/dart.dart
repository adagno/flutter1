import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Color.fromRGBO(92, 40, 40, 1),
            body: SafeArea(
                child: Column(
              //verticalDirection: VerticalDirection.up,
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('images/logo.jpg'),
                ),
                Text(
                  'Ali Dagnosh',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'app devoelopment',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 200.0,
                  width: 447.0,
                  child: Divider(
                    color: Colors.blue,
                  ),
                ),
              ],
            ))));
  }
}
