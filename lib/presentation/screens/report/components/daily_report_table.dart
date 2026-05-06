import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/report_entity.dart';

class DailyReportTable extends StatelessWidget {
  final List<DailyReportEntity> reports;

  const DailyReportTable({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const _EmptyState(message: 'Tidak ada data pendapatan harian');
    }

    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy', 'id_ID');

    // Summary totals
    final totalAmount = reports.fold(0, (sum, r) => sum + r.totalAmount);
    final totalCash = reports.fold(0, (sum, r) => sum + r.cashAmount);
    final totalQris = reports.fold(0, (sum, r) => sum + r.qrisAmount);
    final totalTrx = reports.fold(0, (sum, r) => sum + r.totalTransactions);

    return Column(
      children: [
        _SummaryRow(
          totalAmount: totalAmount,
          totalCash: totalCash,
          totalQris: totalQris,
          totalTrx: totalTrx,
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
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Transaksi'), numeric: true),
                  DataColumn(label: Text('Cash'), numeric: true),
                  DataColumn(label: Text('QRIS'), numeric: true),
                  DataColumn(label: Text('Total'), numeric: true),
                ],
                rows: reports.map((r) {
                  final date = DateTime.tryParse(r.date) ?? DateTime.now();

                  return DataRow(
                    cells: [
                      DataCell(Text(dateFormatter.format(date))),
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
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final int totalAmount;
  final int totalCash;
  final int totalQris;
  final int totalTrx;

  const _SummaryRow({
    required this.totalAmount,
    required this.totalCash,
    required this.totalQris,
    required this.totalTrx,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _SummaryCard(
            label: 'Total',
            value: currency.format(totalAmount),
            sub: '$totalTrx transaksi',
            color: colorScheme.primaryContainer,
          ),
          const SizedBox(width: 8),
          _SummaryCard(
            label: 'Cash',
            value: currency.format(totalCash),
            color: colorScheme.secondaryContainer,
          ),
          const SizedBox(width: 8),
          _SummaryCard(
            label: 'QRIS',
            value: currency.format(totalQris),
            color: colorScheme.tertiaryContainer,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final Color color;

  const _SummaryCard({required this.label, required this.value, this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (sub != null) ...[
              const SizedBox(height: 2),
              Text(sub!, style: Theme.of(context).textTheme.labelSmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
