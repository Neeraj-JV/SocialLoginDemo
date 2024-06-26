import 'package:flutter/material.dart';
import 'package:social_login_demo/addevent/CalenderClient.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarClient calendarClient = CalendarClient();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(days: 1));
  TextEditingController _eventName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Row(
          //   children: <Widget>[
          //     ElevatedButton(
          //         onPressed: () {
          //           DatePicker.showDateTimePicker(context,
          //               showTitleActions: true,
          //               minTime: DateTime(2019, 3, 5),
          //               maxTime: DateTime(2200, 6, 7), onChanged: (date) {
          //             print('change $date');
          //           }, onConfirm: (date) {
          //             setState(() {
          //               this.startTime = date;
          //             });
          //           }, currentTime: DateTime.now(), locale: LocaleType.en);
          //         },
          //         child: Text(
          //           'Event Start Time',
          //           style: TextStyle(color: Colors.blue),
          //         )),
          //     Text('$startTime'),
          //   ],
          // ),
          // Row(
          //   children: <Widget>[
          //     ElevatedButton(
          //         onPressed: () {
          //           DatePicker.showDateTimePicker(context,
          //               showTitleActions: true,
          //               minTime: DateTime(2019, 3, 5),
          //               maxTime: DateTime(2200, 6, 7), onChanged: (date) {
          //             print('change $date');
          //           }, onConfirm: (date) {
          //             setState(() {
          //               this.endTime = date;
          //             });
          //           }, currentTime: DateTime.now(), locale: LocaleType.en);
          //         },
          //         child: Text(
          //           'Event End Time',
          //           style: TextStyle(color: Colors.blue),
          //         )),
          //     Text('$endTime'),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _eventName,
              decoration: InputDecoration(hintText: 'Enter Event name'),
            ),
          ),
          ElevatedButton(
              child: Text(
                'Insert Event',
              ),
              onPressed: () {
                //log('add event pressed');
                calendarClient.insert(
                  _eventName.text,
                  '2023-10-19 10:00:15.014715',
                  '2023-10-19 10:00:15.014715',
                );
              }),
        ],
      ),
    );
  }
}
