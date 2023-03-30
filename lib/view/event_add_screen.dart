import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calender_app/model/event_provider.dart';

class EventAddScreen extends StatefulWidget {
  final DateTime selectedDate;
  const EventAddScreen({Key? key,required this.selectedDate}) : super(key: key);

  @override
  _EventAddScreenState createState() => _EventAddScreenState(selectedDate: selectedDate);
}

class _EventAddScreenState extends State<EventAddScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  bool _isAllDay = false;
  DateTime _startDate = DateTime.now().add(Duration(hours: 1));
  DateTime _endDate = DateTime.now();
  bool _validateTitle = false;

  //タイトルが入力されたら保存ボタン活性化
  bool _isSaveEnabled() {
    return _titleController.text.isNotEmpty;
  }
  //保存ボタンを押したときにEventProviderに追加する処理
  Future<void> _saveEvent() async {
    final title = _titleController.text;
    final startDate = _startDate;
    final endDate = _endDate;
    final comment = _commentController.text;

    final newEvent = title + ' - ' + startDate.toString() + ' - ' + endDate.toString() + ' - ' + comment;

    // EventProviderに予定を追加する
    // final eventProvider = context.read(eventsProvider.notifier);
    // eventProvider.addEvent(newEvent);

    Navigator.of(context).pop(newEvent);
  }

  _EventAddScreenState({required DateTime selectedDate}) {
     _startDate = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '予定の追加',
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: _isSaveEnabled() ? _saveEvent : null,
            child: Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'タイトルを入力してください',
                errorText: _validateTitle ? 'タイトルを入力してください' : null,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              controller: _titleController,
              onChanged: (_) {
                setState(() {
                  _validateTitle = _titleController.text.isEmpty;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('終日'),
                Switch(
                  value: _isAllDay,
                  onChanged: (value) {
                    setState(() {
                      _isAllDay = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('開始'),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_startDate),
                      style: TextStyle(fontSize: 18.0,color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_startDate),
                  );
                  if (time != null) {
                    setState(() {
                      _startDate = DateTime(
                        _startDate.year,
                        _startDate.month,
                        _startDate.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                child: Text(
                  DateFormat('HH:mm').format(_startDate),
                  style: TextStyle(fontSize: 18.0,color: Colors.black),
                ),
              ),
            ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('終了'),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        _endDate = date;
                      });
                    }
                  },
                  child:Padding(padding: EdgeInsets.zero,
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_endDate),
                      style: TextStyle(fontSize: 18.0,color: Colors.black),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_endDate),
                    );
                    if (time != null) {
                      setState(() {
                        _endDate = DateTime(
                          _endDate.year,
                          _endDate.month,
                          _endDate.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                  child: Text(
                    DateFormat('HH:mm').format(_endDate),
                    style: TextStyle(fontSize: 18.0,color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'メモを入力してください',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
            controller: _commentController,
            maxLines: 3,
          ),
        ],
      ),
      ),
    );
  }
}
