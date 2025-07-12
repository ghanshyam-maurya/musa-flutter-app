import 'package:flutter/material.dart';

/// Shows a dialog containing a month and year picker.
///
/// Returns a [Future] that resolves to the selected date (first day of the month)
/// when the user confirms the dialog. If the user cancels, null is returned.
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  DateTime? initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String? cancelText,
  String? confirmText,
  String? helpText,
  Color? primaryColor,
}) async {
  final DateTime initial = initialDate ?? DateTime.now();

  return showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return MonthYearPickerDialog(
        initialDate: initial,
        firstDate: firstDate,
        lastDate: lastDate,
        cancelText: cancelText,
        confirmText: confirmText,
        helpText: helpText,
        primaryColor: primaryColor,
      );
    },
  );
}

/// A dialog that allows selecting month and year only.
class MonthYearPickerDialog extends StatefulWidget {
  const MonthYearPickerDialog({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.primaryColor,
  }) : super(key: key);

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? cancelText;
  final String? confirmText;
  final String? helpText;
  final Color? primaryColor;

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int selectedYear;
  late int selectedMonth;
  late ScrollController monthScrollController;
  late ScrollController yearScrollController;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;

    monthScrollController = ScrollController();
    yearScrollController = ScrollController();

    // Scroll to initial positions after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialPositions();
    });
  }

  @override
  void dispose() {
    monthScrollController.dispose();
    yearScrollController.dispose();
    super.dispose();
  }

  void _scrollToInitialPositions() {
    // Use a longer delay to ensure the ListView is properly built and measured
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        _scrollToMonth();
        _scrollToYear();
      }
    });
  }

  void _scrollToMonth() {
    if (!monthScrollController.hasClients) return;

    final monthIndex = selectedMonth - 1; // 0-based index
    const itemHeight = 48.0;

    // Get the viewport height to calculate center position
    final viewportHeight = monthScrollController.position.viewportDimension;
    final centerOffset = (viewportHeight / 2) - (itemHeight / 2);

    // Calculate scroll offset to center the selected month
    final targetOffset = (monthIndex * itemHeight) - centerOffset;
    final maxScrollExtent = monthScrollController.position.maxScrollExtent;

    // Clamp the offset to valid range
    final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

    print(
        'Month scroll: selectedMonth=$selectedMonth, monthIndex=$monthIndex, targetOffset=$targetOffset, clampedOffset=$clampedOffset');

    monthScrollController.animateTo(
      clampedOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToYear() {
    if (!yearScrollController.hasClients) return;

    // Calculate the index in the reversed list correctly
    // In a reversed list: index 0 = lastDate.year, index 1 = lastDate.year-1, etc.
    // So for selectedYear, we need: lastDate.year - selectedYear
    final yearIndex = widget.lastDate.year - selectedYear;
    const itemHeight = 48.0;

    // Debug: Check if the year is within valid range
    if (selectedYear < widget.firstDate.year ||
        selectedYear > widget.lastDate.year) {
      print(
          'Warning: selectedYear $selectedYear is outside valid range ${widget.firstDate.year}-${widget.lastDate.year}');
      return;
    }

    print(
        'Year scroll: selectedYear=$selectedYear, yearIndex=$yearIndex, firstYear=${widget.firstDate.year}, lastYear=${widget.lastDate.year}');

    // Get the viewport height to calculate center position
    final viewportHeight = yearScrollController.position.viewportDimension;
    final centerOffset = (viewportHeight / 2) - (itemHeight / 2);

    // Calculate scroll offset to center the selected year
    final targetOffset = (yearIndex * itemHeight) - centerOffset;
    final maxScrollExtent = yearScrollController.position.maxScrollExtent;

    // Clamp the offset to valid range
    final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

    print(
        'Year scroll: targetOffset=$targetOffset, maxScrollExtent=$maxScrollExtent, clampedOffset=$clampedOffset');

    yearScrollController.animateTo(
      clampedOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = widget.primaryColor ?? theme.colorScheme.primary;
    final ColorScheme colorScheme =
        theme.colorScheme.copyWith(primary: primaryColor);
    final TextTheme textTheme = theme.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 328,
        height: 420,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.helpText ?? 'Select month and year',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_getMonthName(selectedMonth)} $selectedYear',
                    style: textTheme.headlineSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Month and Year selectors
            Expanded(
              child: Row(
                children: [
                  // Month selector
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Text(
                            'Month',
                            style: textTheme.titleSmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: monthScrollController,
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              final month = index + 1;
                              final isSelected = month == selectedMonth;
                              final isEnabled = _isMonthEnabled(month);

                              return InkWell(
                                onTap: isEnabled
                                    ? () {
                                        setState(() {
                                          selectedMonth = month;
                                        });
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor.withOpacity(0.1)
                                        : null,
                                    border: isSelected
                                        ? Border(
                                            left: BorderSide(
                                              color: primaryColor,
                                              width: 3,
                                            ),
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    _getMonthName(month),
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: isEnabled
                                          ? (isSelected
                                              ? primaryColor
                                              : colorScheme.onSurface)
                                          : colorScheme.onSurface
                                              .withOpacity(0.38),
                                      fontWeight:
                                          isSelected ? FontWeight.w600 : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    color: colorScheme.outline.withOpacity(0.2),
                  ),

                  // Year selector
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Text(
                            'Year',
                            style: textTheme.titleSmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: yearScrollController,
                            itemCount: widget.lastDate.year -
                                widget.firstDate.year +
                                1,
                            reverse: true, // Show recent years first
                            itemBuilder: (context, index) {
                              final year = widget.lastDate.year - index;
                              final isSelected = year == selectedYear;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedYear = year;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor.withOpacity(0.1)
                                        : null,
                                    border: isSelected
                                        ? Border(
                                            left: BorderSide(
                                              color: primaryColor,
                                              width: 3,
                                            ),
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    year.toString(),
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: isSelected
                                          ? primaryColor
                                          : colorScheme.onSurface,
                                      fontWeight:
                                          isSelected ? FontWeight.w600 : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    child: Text(widget.cancelText ?? 'Cancel'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      final selectedDate =
                          DateTime(selectedYear, selectedMonth, 1);
                      Navigator.of(context).pop(selectedDate);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: primaryColor.withOpacity(0.1),
                    ),
                    child: Text(
                      widget.confirmText ?? 'OK',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  bool _isMonthEnabled(int month) {
    final testDate = DateTime(selectedYear, month, 1);
    final firstOfMonth =
        DateTime(widget.firstDate.year, widget.firstDate.month, 1);
    final lastOfMonth =
        DateTime(widget.lastDate.year, widget.lastDate.month, 1);

    return !testDate.isBefore(firstOfMonth) && !testDate.isAfter(lastOfMonth);
  }
}
