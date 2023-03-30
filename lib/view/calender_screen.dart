import 'package:calender_app/view/event_dialog.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MyWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final VoidCallback? onAddPressed;

  const MyWidget({Key? key, this.selectedDate, this.onAddPressed}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List> _events;

  //後でcommonに移動する
  final Color _weekdayColor = Colors.black;
  final Color _saturdayColor = Colors.blue;
  final Color _sundayColor = Colors.red;
  final Color _todayMarkerColor = Colors.blue;
  final Color _eventMarkerColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDate = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _events = _generateEvents(DateTime.now());
  }

  Map<DateTime, List> _generateEvents(DateTime baseDate) {
    // イベントの生成ロジック
    return {};
  }

  void _onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      _selectedDate = selectedDate;
      _focusedDate = focusedDate;
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.today),
          onPressed: () {
            setState(() {
              _selectedDate = DateTime.now();
              _focusedDate = DateTime.now();
            });
          },
        ),
        Text(
          'カレンダー',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
                _focusedDate = picked;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    _events = _generateEvents(DateTime.now());
    return TableCalendar(
      firstDay: DateTime.utc(2015, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: _focusedDate,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
      calendarFormat: _calendarFormat,
      //eventLoader: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        //TODO actionsBuilderで引っかかる
        // actionsBuilder: (context, date, _) {
        //   return [
        //     IconButton(
        //       onPressed: () async {
        //         final picked = await showDatePicker(
        //           context: context,
        //           initialDate: DateTime.now(),
        //           firstDate: DateTime(2000),
        //           lastDate: DateTime(2100),
        //         );
        //         if (picked != null) {
        //           setState(() {
        //             _selectedDate = picked;
        //             _focusedDate = picked;
        //           });
        //         }
        //       },
        //       icon: Icon(Icons.today),
        //     ),
        //   ];
        // },
      ),
      calendarStyle: CalendarStyle(
        //平日と土曜だけなぜかエラー　3.0.0以降対応してるはずなのに・・
        //weekdayStyle: TextStyle(color: _weekdayColor),
        //saturdaytextStyle: TextStyle(color: _saturdayColor),
        holidayTextStyle: TextStyle(color: _sundayColor),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: _todayMarkerColor),
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: _eventMarkerColor,
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) async {
        await showDialog(
          context: context,
          builder: (context) => EventDialog(
            selectedDate: selectedDay, 
            //onAddPressed: () {},
            date: DateTime.now(),//TODO今日のパラメータを渡してるから後で修正
          ),
        );
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      availableGestures: AvailableGestures.none, // スライドボタンを非表示にする
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildHeader(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildCalendar(context),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


         
