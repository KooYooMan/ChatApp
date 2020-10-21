import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
TextStyle timeStampTextStyle() {
  return TextStyle(
    color: Colors.grey,
    fontSize: 12.0,
    fontStyle: FontStyle.normal
  );
}

class TimeStampWidget extends StatelessWidget {
  TimeStampWidget(this.timeStamp);

  final DateTime timeStamp;
  @override
  Widget build(BuildContext context) {
    String timeStampString = "";
    if (DateTime.now().difference(timeStamp).inDays >= 3) {
      timeStampString = DateFormat('d MMM yyyy, hh:mm a').format(timeStamp);
    } else if (DateTime.now().weekday != timeStamp.weekday){
      timeStampString = DateFormat('EEE h:mm a').format(timeStamp);
    } else {
      timeStampString = DateFormat('hh:mm a').format(timeStamp);
    }
    return Center(
      child: Text(
        timeStampString,
        style: timeStampTextStyle(),
      ),
    );
  }
}
