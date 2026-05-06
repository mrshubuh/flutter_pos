import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/report_entity.dart';

class MonthlyReportTable extends StatelessWidget {
  final List<MonthlyReportEntity> reports;

  const MonthlyReportTable({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_outlined, size: 48),
            SizedBox(height: 12),
            Text('Tidak ada data pendapatan bulanan'),
          ],
        ),
      );
    }

    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final totalAmount = reports.fold(0, (sum, r) => sum + r.totalAmount);
    final totalCash = reports.fold(0, (sum, r) => sum + r.cashAmount);
    final totalQris = reports.fold(0, (sum, r) => sum + r.qrisAmount);
    final totalTrx = reports.fold(0, (sum, r) => sum + r.totalTransactions);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _InfoChip(label: 'Total Omzet', value: currency.format(totalAmount)),
              const SizedBox(width: 8),
              _InfoChip(label: 'Transaksi', value: totalTrx.toString()),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                columns: const [
                  DataColumn(label: Text('Bulan')),
                  DataColumn(label: Text('Transaksi'), numeric: true),
                  DataColumn(label: Text('Cash'), numeric: true),
                  DataColumn(label: Text('QRIS'), numeric: true),
                  DataColumn(label: Text('Total'), numeric: true),
                ],
                rows: [
                  ...reports.map((r) {
                    final parts = r.month.split('-');
                    final monthName = parts.length == 2
                        ? DateFormat('MMMM yyyy', 'id_ID').format(
                            DateTime(int.parse(parts[0]), int.parse(parts[1])),
                          )
                        : r.month;

                    return DataRow(
                      cells: [
                        DataCell(Text(monthName)),
                        DataCell(Text(r.totalTransactions.toString())),
                        DataCell(Text(currency.format(r.cashAmount))),
                        DataCell(Text(currency.format(r.qrisAmount))),
                        DataCell(
                          Text(
                            currency.format(r.totalAmount),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  }),
                  // Total row
                  DataRow(
                    color: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    ),
                    cells: [
                      const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(totalTrx.toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(
                        Text(currency.format(totalCash), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataCell(
                        Text(currency.format(totalQris), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataCell(
                        Text(
                          currency.format(totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 2),
            Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
