import 'package:flutter/material.dart';
import '../util/notifications.dart';


class ReminderPage extends StatefulWidget{

  ReminderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  var _notifications = Notifications();

  @override
  Widget build(BuildContext context) {
    _notifications.init();
    var timeController = TextEditingController();
    var noteController = TextEditingController();

  //   @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   timeController.dispose();
  //   noteController.dispose();
  //   super.dispose();
  // }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[        
        ],
      ),
      body: new Form(
        key: _formKey,
        child: Column(
          
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: TextFormField(
                controller: timeController,
                decoration: InputDecoration(
                  hintText: "Time in Minutes (example: 35)",
                  icon: Icon(Icons.access_time)
                ),
                onSaved: (String value) {
                  print('Saving time $value');
                  timeController.text = value;
                },
                validator: (String value) {
                  print('Validating $value');
                  if (value.length == 0) {
                    return 'Invalid time';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: "''Wear a jacket to dinner''",
                icon: Icon(Icons.create)
              ),
              onSaved: (String value) {
                  print('Saving note $value');
                  noteController.text = value;
              },
              validator: (String value) {
                print('Validating $value');
                if (value.length == 0) {
                  return 'Invalid note';
                } else {
                  return null;
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: FlatButton.icon(
                icon: Icon(Icons.add_alarm),
                label: Text('Add New Reminder'),
                onPressed: () { 
                    _displaySnackBar(context);
                    _notificationLater(noteController.text, timeController.text);
                }
              ),
            ),

            FlatButton.icon(
              label: Text('See Upcoming Reminders'),
              icon: Icon(Icons.list),
              onPressed: _showPendingNotifications,
            ),  
          ],
        ),
      ),
    );
  }

  // void _notificationNow() {
  //   _notifications.sendNotificationNow('title', 'body', 'payload');
  // }

    _displaySnackBar(BuildContext context) {
      if (_formKey.currentState.validate()) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Creating notification...'),
                    ));  
      }
    }

  Future<void> _notificationLater(String note, String time) async {
    var when = DateTime.now().add(Duration(minutes: int.parse(time)));
    // print(when);
    if (int.parse(time) == 1) {
      await _notifications.sendNotificationLater('Reminder made ' + time + ' minute ago: ', note, when, 'payload');
    } else {
      await _notifications.sendNotificationLater('Reminder (' + time + ' minutes ago): ', note, when, 'payload');
    }
    
  }

  Future<void> _showPendingNotifications() async {
    var pendingNotificationRequests = await _notifications.getPendingNotificationRequests();
    var pendingString = '';
    
    print('Pending requests:');
    for (var pendingRequest in pendingNotificationRequests) {
      print('${pendingRequest.id}/${pendingRequest.title}/${pendingRequest.body}');
      pendingString = pendingString + '${pendingRequest.title}' + '\n\t\t${pendingRequest.body}\n';

    }
    if(pendingString == '') {
      pendingString = 'You have no upcoming reminders!';
    }

    showDialog<void>(
      barrierDismissible: true, 
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Upcoming Reminders'),
          content: Text(
            pendingString, 
            style: TextStyle(fontStyle: FontStyle.italic),),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

}