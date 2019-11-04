import 'package:flutter/material.dart';

class WeatherView extends StatefulWidget {
  WeatherView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.title),
        title: Text('Oshawa, ON'),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Column(
                  children: <Widget>[
                    Text('08\xb0', style: TextStyle(fontSize: 50)),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                      Icon(Icons.cloud),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text('Rain', style: TextStyle(fontSize: 14)),
                    ]),
                    Row(
                      children: <Widget>[
                      Icon(Icons.arrow_forward),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text('11 kph', style: TextStyle(fontSize: 14)),
                    ]),
                    Row(
                      children: <Widget>[
                      Icon(Icons.beach_access),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text('37%', style: TextStyle(fontSize: 14)),
                    ]),
                  ],
                ),
              ]
            ),
            // 5 day forecast box
            Padding(padding: EdgeInsets.symmetric(vertical: 150)),
            Container(
              // decoration: BoxDecoration(border: Border.all(
              //   color: Colors.grey,
              //   width: 1.0,
              //   style: BorderStyle.solid,
              // )),
              child: Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Monday'),
                      Icon(Icons.wb_sunny),
                      Row (
                        children: <Widget>[
                          Text('10\xb0'),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text('4\xb0'),
                        ],
                      ),
                    ]
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Column(
                    children: <Widget>[
                      Text('Tuesday'),
                      Icon(Icons.wb_cloudy),
                      Row (
                        children: <Widget>[
                          Text('6\xb0'),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text('2\xb0'),
                        ],
                      ),
                    ]
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Column(
                    children: <Widget>[
                      Text('Wednesday'),
                      Icon(Icons.wb_sunny),
                      Row (
                        children: <Widget>[
                          Text('6\xb0'),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text('4\xb0'),
                        ],
                      ),
                    ]
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Column(
                    children: <Widget>[
                      Text('Thursday'),
                      Icon(Icons.wb_cloudy),
                      Row (
                        children: <Widget>[
                          Text('7\xb0'),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text('2\xb0'),
                        ],
                      ),
                    ]
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Column(
                    children: <Widget>[
                      Text('Friday'),
                      Icon(Icons.wb_sunny),
                      Row (
                        children: <Widget>[
                          Text('12\xb0'),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text('7\xb0'),
                        ],
                      ),
                    ]
                  ),
                ],
              )
            )
  
          ]
        )
      ),

      drawer: Drawer(
        child:  ListView(
          //padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Manage Locations'),
              onTap: () {
                print("Manage locations pressed...");
              }
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Item 2'),
              onTap: () {
                print("Item 2 pressed...");
              }
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                print("Settings pressed...");
              }
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Close'),
              onTap: () {
                Navigator.pop(context);
              }
            )
          ],
        ),
      ),
      //bottomSheet: menu(), 
    );
  }
}