import 'package:flutter/material.dart';
import 'package:facultyreservation/search/date_widget.dart';
import 'package:facultyreservation/search/extra/color.dart';
import 'package:facultyreservation/search/extra/style.dart';
import 'package:facultyreservation/search/gestures/tap.dart';
import 'package:intl/date_symbol_data_local.dart';

class DatePicker extends StatefulWidget {
  final DateTime startDate;
  final double width;
  final double height;
  final DatePickerController? controller;
  final Color selectedTextColor;
  final Color selectionColor;
  final Color deactivatedColor;
  final TextStyle monthTextStyle;
  final TextStyle dayTextStyle;
  final TextStyle dateTextStyle;
  final DateTime? initialSelectedDate;
  final List<DateTime>? inactiveDates;
  final List<DateTime>? activeDates;
  final DateChangeListener? onDateChange;
  final int daysCount;
  final String locale;

  DatePicker({
    required this.startDate,
    Key? key,
    this.width = 60,
    this.height = 80,
    this.controller,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectedTextColor = Colors.white,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.deactivatedColor = AppColors.defaultDeactivatedColor,
    this.initialSelectedDate,
    this.activeDates,
    this.inactiveDates,
    this.onDateChange,
    this.daysCount = 500,
    this.locale = "en_US",
  }) : assert(
          activeDates == null || inactiveDates == null,
          "Can't provide both activated and deactivated dates List at the same time.",
        );

  @override
  State<StatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _currentDate;
  late final TextStyle selectedDateStyle;
  late final TextStyle selectedMonthStyle;
  late final TextStyle selectedDayStyle;
  late final TextStyle deactivatedDateStyle;
  late final TextStyle deactivatedMonthStyle;
  late final TextStyle deactivatedDayStyle;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    initializeDateFormatting(widget.locale, null);
    _currentDate = widget.initialSelectedDate;
    widget.controller?.setDatePickerState(this);
    this.selectedDateStyle = widget.dateTextStyle.copyWith(color: widget.selectedTextColor);
    this.selectedMonthStyle = widget.monthTextStyle.copyWith(color: widget.selectedTextColor);
    this.selectedDayStyle = widget.dayTextStyle.copyWith(color: widget.selectedTextColor);
    this.deactivatedDateStyle = widget.dateTextStyle.copyWith(color: widget.deactivatedColor);
    this.deactivatedMonthStyle = widget.monthTextStyle.copyWith(color: widget.deactivatedColor);
    this.deactivatedDayStyle = widget.dayTextStyle.copyWith(color: widget.deactivatedColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.daysCount,
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          DateTime date;
          DateTime _date = widget.startDate.add(Duration(days: index));
          date = DateTime(_date.year, _date.month, _date.day);

          bool isDeactivated = false;

          if (widget.inactiveDates != null) {
            for (DateTime inactiveDate in widget.inactiveDates!) {
              if (DateUtils.isSameDay(date, inactiveDate)) {
                isDeactivated = true;
                break;
              }
            }
          }

          if (widget.activeDates != null) {
            isDeactivated = true;
            for (DateTime activateDate in widget.activeDates!) {
              if (DateUtils.isSameDay(date, activateDate)) {
                isDeactivated = false;
                break;
              }
            }
          }

          bool isSelected = _currentDate != null ? DateUtils.isSameDay(date, _currentDate!) : false;

          return DateWidget(
            date: date,
            monthTextStyle: isDeactivated
                ? deactivatedMonthStyle
                : isSelected
                    ? selectedMonthStyle
                    : widget.monthTextStyle,
            dateTextStyle: isDeactivated
                ? deactivatedDateStyle
                : isSelected
                    ? selectedDateStyle
                    : widget.dateTextStyle,
            dayTextStyle: isDeactivated
                ? deactivatedDayStyle
                : isSelected
                    ? selectedDayStyle
                    : widget.dayTextStyle,
            width: widget.width,
            locale: widget.locale,
            selectionColor: isSelected ? widget.selectionColor : Colors.transparent,
            onDateSelected: (selectedDate) {
              if (isDeactivated) return;
              widget.onDateChange?.call(selectedDate);
              setState(() {
                _currentDate = selectedDate;
              });
            },
          );
        },
      ),
    );
  }
}

class DatePickerController {
  _DatePickerState? _datePickerState;

  void setDatePickerState(_DatePickerState state) {
    _datePickerState = state;
  }

  void jumpToSelection() {
    assert(_datePickerState != null, 'DatePickerController is not attached to any DatePicker View.');
    _datePickerState!._controller.jumpTo(_calculateDateOffset(_datePickerState!._currentDate!));
  }

  void animateToSelection({
    duration = const Duration(milliseconds: 500),
    curve = Curves.linear,
  }) {
    assert(_datePickerState != null, 'DatePickerController is not attached to any DatePicker View.');
    _datePickerState!._controller.animateTo(
      _calculateDateOffset(_datePickerState!._currentDate!),
      duration: duration,
      curve: curve,
    );
  }

  void animateToDate(DateTime date, {
    duration = const Duration(milliseconds: 500),
    curve = Curves.linear,
  }) {
    assert(_datePickerState != null, 'DatePickerController is not attached to any DatePicker View.');
    _datePickerState!._controller.animateTo(
      _calculateDateOffset(date),
      duration: duration,
      curve: curve,
    );
  }

  void setDateAndAnimate(DateTime date, {
    duration = const Duration(milliseconds: 500),
    curve = Curves.linear,
  }) {
    assert(_datePickerState != null, 'DatePickerController is not attached to any DatePicker View.');
    _datePickerState!._controller.animateTo(
      _calculateDateOffset(date),
      duration: duration,
      curve: curve,
    );

    if (date.compareTo(_datePickerState!.widget.startDate) >= 0 &&
        date.compareTo(_datePickerState!.widget.startDate.add(Duration(days: _datePickerState!.widget.daysCount))) <= 0) {
      _datePickerState!._currentDate = date;
    }
  }

  double _calculateDateOffset(DateTime date) {
    final startDate = DateTime(
      _datePickerState!.widget.startDate.year,
      _datePickerState!.widget.startDate.month,
      _datePickerState!.widget.startDate.day,
    );

    int offset = date.difference(startDate).inDays;
    return (offset * _datePickerState!.widget.width) + (offset * 6);
  }
}
