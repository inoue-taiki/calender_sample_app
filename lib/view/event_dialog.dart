import 'package:calender_app/view/event_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDialog extends StatefulWidget {
  final DateTime date;
  final DateTime selectedDate; 

  const EventDialog({Key? key, required this.date,required this.selectedDate}) : super(key: key);

  @override
  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  List<String> events = [];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogWidth = screenWidth * 0.8;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${DateFormat('yyyy/MM/dd(EEE)').format(widget.date)}'),
          TextButton.icon(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EventAddScreen(selectedDate: widget.selectedDate),
                ),
              );
              if (result != null) {
                setState(() {
                  events.add(result);
                });
              }
            },
            icon: Icon(Icons.add),
            label: Text(''),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.0),
          for (var event in events) Text(event),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(''),
        ),
      ],
      insetPadding: EdgeInsets.all(24.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}
