import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportDateFilter extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime, DateTime) onDateRangeChanged;

  const ReportDateFilter({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy', 'id_ID');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _pickDateRange(context),
              child: Text(
                '${formatter.format(startDate)} – ${formatter.format(endDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );

    if (picked != null) {
      onDateRangeChanged(picked.start, picked.end);
    }
  }
}
