import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart' show ItemPositionsListener, ItemScrollController, ScrollablePositionedList;
import 'package:youth_bridge/widgets/themes.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  final List<DateTime> _months = [];

  @override
  void initState() {
    super.initState();
    _generateMonths();
    _focusedDay = _focusedDay.isBefore(DateTime.utc(2020, 1, 1))
        ? DateTime.utc(2020, 1, 1)
        : (_focusedDay.isAfter(DateTime.utc(2030, 12, 31))
            ? DateTime.utc(2030, 12, 31)
            : _focusedDay);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  void _generateMonths() {
    DateTime firstMonth = DateTime.utc(2020, 1, 1);
    DateTime lastMonth = DateTime.utc(2030, 12, 1);
    for (DateTime month = firstMonth; month.isBefore(lastMonth); month = DateTime(month.year, month.month + 1)) {
      _months.add(month);
    }
  }

  void _scrollToCurrentMonth() {
    int index = _months.indexWhere((month) => month.year == _focusedDay.year && month.month == _focusedDay.month);
    if (index != -1) {
      _scrollController.jumpTo(index: index);
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  String _getMonthName(DateTime date) {
    return "${date.year} ${["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][date.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemPositionsListener: _itemPositionsListener,
        itemCount: _months.length,
        itemBuilder: (context, index) {
          return _buildMonthView(_months[index]);
        },
      ),
    );
  }

  Widget _buildMonthView(DateTime month) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _getMonthName(month),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10,),
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2040, 12, 31),
          focusedDay: month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: _onDaySelected,
          rowHeight: 70,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            cellMargin: EdgeInsets.all(6.0),
          ),
          headerVisible: false,
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(fontSize: 18.0),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Divider(thickness: 1, color: Colors.black12,),
      ],
    );
  }
}
