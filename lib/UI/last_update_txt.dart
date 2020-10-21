import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdateStatusText extends StatelessWidget {
  final DateTime lastUpdated;
  LastUpdateStatusText({Key key, @required this.lastUpdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateText = '';

    if (lastUpdated != null) {
      DateFormat dateFormat = DateFormat.yMd().add_Hms();
      dateText = 'Last Updated: ${dateFormat.format(lastUpdated)}';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 1),
      child: Text(dateText, textAlign: TextAlign.center),
    );
  }
}
