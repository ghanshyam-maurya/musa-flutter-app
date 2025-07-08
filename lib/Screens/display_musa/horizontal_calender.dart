import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musa_app/Resources/colors.dart';

class HorizontalCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  const HorizontalCalendar({
    Key? key,
    required this.onDateSelected,
    this.selectedDate,
  }) : super(key: key);

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late DateTime currentMonth;
  late PageController pageController;
  DateTime? selectedDate;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    selectedDate = widget.selectedDate;
    pageController = PageController(initialPage: 0);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> getDaysInMonth(DateTime month) {
    final today = DateTime.now();
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    // If current month and year, only include days up to today
    if (month.year == today.year && month.month == today.month) {
      return List.generate(
        today.day,
        (index) => DateTime(month.year, month.month, index + 1),
      );
    } else if (month.isAfter(DateTime(today.year, today.month))) {
      // If the month is after the current month, return an empty list
      return [];
    } else if (month.year > today.year) {
      // If the year is after the current year, return an empty list
      return [];
    } else {
      // For past months, include all days
      return List.generate(
        lastDay.day,
        (index) => DateTime(month.year, month.month, index + 1),
      );
    }
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    final days = getDaysInMonth(currentMonth);
    if (selectedDate != null) {
      final index = days.indexWhere((d) =>
          d.day == selectedDate!.day &&
          d.month == selectedDate!.month &&
          d.year == selectedDate!.year);
      if (index != -1 && _scrollController.hasClients) {
        // Center the selected date if possible
        final double itemWidth = 58; // width + margin (50+4*2)
        final double screenWidth = MediaQuery.of(context).size.width;
        final double offset =
            (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
        _scrollController.animateTo(
          offset.clamp(0, _scrollController.position.maxScrollExtent),
          duration: Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isCurrentMonth =
        currentMonth.year == today.year && currentMonth.month == today.month;
    final isFutureMonth = currentMonth.year > today.year ||
        (currentMonth.year == today.year && currentMonth.month > today.month);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Month/Year header with navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: SvgPicture.asset(
                    'assets/svgs/arrow_left.svg',
                    color: Color(0xFF00674E),
                    width: 24,
                    height: 24,
                  ),
                ),
                Text(
                  DateFormat('MMMM, yyyy').format(currentMonth),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00674E),
                  ),
                ),
                IconButton(
                  onPressed: isCurrentMonth ? null : _nextMonth,
                  icon: SvgPicture.asset(
                    'assets/svgs/arrow_right.svg',
                    color:
                        isCurrentMonth ? Color(0xFFCCE1DC) : Color(0xFF00674E),
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
          // Horizontal scrollable dates
          Container(
            height: 80, // Fixed height to prevent overflow
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: getDaysInMonth(currentMonth).length,
              itemBuilder: (context, index) {
                final date = getDaysInMonth(currentMonth)[index];
                final isSelected = selectedDate != null &&
                    date.day == selectedDate!.day &&
                    date.month == selectedDate!.month &&
                    date.year == selectedDate!.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToSelectedDate();
                    });
                    widget.onDateSelected(date);
                  },
                  child: Container(
                    width: 50, // Increased width significantly
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF00674E) : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xFFCCE1DC), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            DateFormat('EEE', 'en_US')
                                .format(date)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : Color.fromRGBO(0, 103, 78, 0.47),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 2),
                        Flexible(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColor.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
