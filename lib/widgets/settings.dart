/*
basic settings page where the user can customize the
app to their liking
*/
import 'package:dynamic_theme/dynamic_theme.dart';
import "package:flutter/material.dart";

class SettingsPage extends StatefulWidget{

  String title;

  SettingsPage({this.title});

  @override
  _buildSettingsPage createState() => _buildSettingsPage();
}

class _buildSettingsPage extends State<SettingsPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Switch(
                  value: Theme.of(context).brightness == Brightness.light? false: true,
                  onChanged: (value){
                    setState(() {
                      if(value){
                        DynamicTheme.of(context).setBrightness(Brightness.dark);
                      }else{
                        DynamicTheme.of(context).setBrightness(Brightness.light);
                      }
                      
                    });
                  },
                ),
                Text("Dark Mode"),
              ],
            ),
            Row(
              children: <Widget>[
                Switch(
                  value: false,
                  
                  onChanged: (value){
                    setState(() {
                      //if(value) value = false;
                      //else value = true;
                    });
                  }
                ),
                Text("Notifications"),
              ],
            ),
            Row(
              children: <Widget>[
                Switch(
                  value: false,
                  onChanged: (value){
                    setState(() {
                      //if(value) value = false;
                      //else value = true;
                    });
                  }
                ),
                Text("Display Fahrenheit"),
              ],
            ),
          ],
        ),
      ),
    );
  }

}