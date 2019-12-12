import 'package:flutter/material.dart';
import '../util/notifications.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ReminderPage extends StatefulWidget {
  ReminderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _eventDate = DateTime.now();

  var _notifications = Notifications();

  @override
  Widget build(BuildContext context) {
    // init notification
    _notifications.init();
    // declare currrent date
    DateTime now = DateTime.now();

    //keep track of note
    var noteController = TextEditingController();

    return Scaffold(
      // key for snackbar integration
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Form(
        // key to track form
        key: _formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, top: 10, bottom: 20),
              child: Row(children: [
                // button for picking date
                RaisedButton(
                  child: Text(FlutterI18n.translate(context, "reminder.select_date")),
                  textColor: Colors.white,
                  color: Colors.grey,
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: now,
                      lastDate: DateTime(2100),
                      initialDate: now,
                    ).then((value) {
                      setState(() {
                        _eventDate = DateTime(
                          value.year,
                          value.month,
                          value.day,
                          _eventDate.hour,
                          _eventDate.minute,
                          _eventDate.second,
                        );
                      });
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(_toDateString(_eventDate)),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RaisedButton(
                    child: Text(FlutterI18n.translate(context, "reminder.select_time")),
                    textColor: Colors.white,
                    color: Colors.grey,
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: now.hour,
                          minute: now.minute,
                        ),
                      ).then((value) {
                        setState(() {
                          _eventDate = DateTime(
                            _eventDate.year,
                            _eventDate.month,
                            _eventDate.day,
                            value.hour,
                            value.minute,
                          );
                        });
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(_toTimeString(_eventDate)),
                  ),
                ],
              ),
            ),
            // textfield to update note
            Padding(
              padding: EdgeInsets.only(top: 5, left: 15),
              child: TextFormField(
                controller: noteController,
                decoration: InputDecoration(
                    hintText: "''${FlutterI18n.translate(context, "reminder.jacket")}''",
                    icon: Icon(Icons.create)),
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
            ),
            // button to create reminder
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: FlatButton.icon(
                  icon: Icon(Icons.add_alarm),
                  label: Text(FlutterI18n.translate(context, "reminder.add_new_reminder")),
                  onPressed: () {
                    print(_eventDate.toString());
                    if (_toDateInt(_eventDate) > _toDateInt(now)) {
                      _displaySnackBar(context, "${FlutterI18n.translate(context, "reminder.creating_notification")}...");
                      _notificationLater(noteController.text, _eventDate);
                    } else if (_toTimeInt(_eventDate) < _toTimeInt(now)) {
                      _displaySnackBar(context, FlutterI18n.translate(context, "reminder.invalid"));
                    } else {
                      _displaySnackBar(context, "${FlutterI18n.translate(context, "reminder.creating_notification")}...");
                      _notificationLater(noteController.text, _eventDate);
                    }
                  }),
            ),
            // button to see any pending reminders
            Expanded(
              child: FlatButton.icon(
                label: Text(FlutterI18n.translate(context, "reminder.see_upcoming_reminders")),
                icon: Icon(Icons.list),
                onPressed: _showPendingNotifications,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _notificationNow() {
  //   _notifications.sendNotificationNow('title', 'body', 'payload');
  // }

  _displaySnackBar(BuildContext context, String s) {
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(s),
      ));
    }
  }

  Future<void> _notificationLater(String note, DateTime when) async {
    // var when = DateTime.now().add(Duration(minutes: int.parse(time)));
    // print(when);
    await _notifications.sendNotificationLater(
        'Reminder (made on ' +
            _toDateString(DateTime.now()) +
            ' at ' +
            _toTimeString(DateTime.now()) +
            ') ',
        note,
        when,
        'payload');
  }

  Future<void> _showPendingNotifications() async {
    var pendingNotificationRequests =
        await _notifications.getPendingNotificationRequests();
    var pendingString = '';

    print('Pending requests:');
    for (var pendingRequest in pendingNotificationRequests) {
      print(
          '${pendingRequest.id}/${pendingRequest.title}/${pendingRequest.body}');
      pendingString = pendingString +
          '${pendingRequest.title}' +
          '\n\t\t${pendingRequest.body}\n';
    }
    if (pendingString == '') {
      pendingString = '${FlutterI18n.translate(context, "reminder.no_upcoming")}!';
    }

    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FlutterI18n.translate(context, "reminder.your_upcoming_reminders")),
          content: Text(
            pendingString,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(FlutterI18n.translate(context, "menus.close")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //convert to two digits
  String _twoDigits(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  // convert time to string
  String _toTimeString(DateTime dateTime) {
    return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
  }

  //used to check if time is valid
  int _toTimeInt(DateTime dateTime) {
    String time = '${_twoDigits(dateTime.hour)}${_twoDigits(dateTime.minute)}';
    return int.parse(time);
  }

  // convert date to yyyy/mm/dd
  String _toDateString(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

  // used to check if date is the same day or not
  int _toDateInt(DateTime dateTime) {
    String date = '${dateTime.year}${dateTime.month}${dateTime.day}';
    return int.parse(date);
  }
}
