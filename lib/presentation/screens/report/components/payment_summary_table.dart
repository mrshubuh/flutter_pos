import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/report_entity.dart';

class PaymentSummaryTable extends StatelessWidget {
  final PaymentSummaryEntity? summary;

  const PaymentSummaryTable({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    if (summary == null || summary!.totalTransactions == 0) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.payment_outlined, size: 48),
            SizedBox(height: 12),
            Text('Tidak ada data pembayaran'),
          ],
        ),
      );
    }

    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final s = summary!;

    final cashPct = s.totalAmount > 0 ? (s.cashAmount / s.totalAmount * 100).toStringAsFixed(1) : '0';
    final qrisPct = s.totalAmount > 0 ? (s.qrisAmount / s.totalAmount * 100).toStringAsFixed(1) : '0';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Pembayaran', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          // Payment breakdown cards
          Row(
            children: [
              Expanded(
                child: _PaymentCard(
                  icon: Icons.money,
                  label: 'Cash',
                  amount: currency.format(s.cashAmount),
                  transactions: s.cashTransactions,
                  percentage: cashPct,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentCard(
                  icon: Icons.qr_code_scanner,
                  label: 'QRIS',
                  amount: currency.format(s.qrisAmount),
                  transactions: s.qrisTransactions,
                  percentage: qrisPct,
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Summary table
          DataTable(
            headingRowColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            columns: const [
              DataColumn(label: Text('Metode')),
              DataColumn(label: Text('Transaksi'), numeric: true),
              DataColumn(label: Text('Jumlah'), numeric: true),
              DataColumn(label: Text('%'), numeric: true),
            ],
            rows: [
              DataRow(
                cells: [
                  const DataCell(Row(
                    children: [Icon(Icons.money, size: 16, color: Colors.green), SizedBox(width: 4), Text('Cash')],
                  )),
                  DataCell(Text(s.cashTransactions.toString())),
                  DataCell(Text(currency.format(s.cashAmount))),
                  DataCell(Text('$cashPct%')),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Row(
                    children: [
                      Icon(Icons.qr_code_scanner, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text('QRIS'),
                    ],
                  )),
                  DataCell(Text(s.qrisTransactions.toString())),
                  DataCell(Text(currency.format(s.qrisAmount))),
                  DataCell(Text('$qrisPct%')),
                ],
              ),
              DataRow(
                color: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                ),
                cells: [
                  const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(
                    Text(s.totalTransactions.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataCell(
                    Text(
                      currency.format(s.totalAmount),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const DataCell(Text('100%', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final int transactions;
  final String percentage;
  final Color color;

  const _PaymentCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.transactions,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(amount, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            '$transactions transaksi · $percentage%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
