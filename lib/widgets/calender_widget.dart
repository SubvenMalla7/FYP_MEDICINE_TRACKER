import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  CalendarController _calendarController;
  String selectedDate = DateFormat.E().format(DateTime.now());
  String dat;
  String dateTitle = 'Today';

  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _playAnimation(),
        builder: (context, snapshot) {
          return ScaleTransition(
            scale: _scaleAnimation,
            child: Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TableCalendar(
                          initialCalendarFormat: CalendarFormat.week,
                          calendarStyle: CalendarStyle(
                            todayColor: Theme.of(context).accentColor,
                            selectedColor: Theme.of(context).primaryColor,
                          ),
                          calendarController: _calendarController,
                          availableGestures: AvailableGestures.horizontalSwipe,
                          onDaySelected: (date, event) {
                            setState(() {
                              dat = DateFormat('yyyy-MM-dd').format(date);
                              selectedDate = DateFormat.E().format(date);
                              if (dat !=
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now())) {
                                dateTitle = '';
                              }
                              if (dat ==
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now())) {
                                dateTitle = 'Today';
                              }
                            });
                          },
                        ),
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: '$dateTitle',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              children: [
                                TextSpan(
                                  text: '  $selectedDate ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
