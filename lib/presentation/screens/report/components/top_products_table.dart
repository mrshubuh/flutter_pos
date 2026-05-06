import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/report_entity.dart';

class TopProductsTable extends StatelessWidget {
  final List<TopProductEntity> products;

  const TopProductsTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48),
            SizedBox(height: 12),
            Text('Tidak ada data produk terlaris'),
          ],
        ),
      );
    }

    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          columns: const [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Nama Produk')),
            DataColumn(label: Text('Qty Terjual'), numeric: true),
            DataColumn(label: Text('Total Pendapatan'), numeric: true),
          ],
          rows: products.asMap().entries.map((entry) {
            final index = entry.key;
            final p = entry.value;

            return DataRow(
              cells: [
                DataCell(
                  index < 3
                      ? Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: [Colors.amber, Colors.grey, Colors.brown][index],
                          ),
                        )
                      : Text('${index + 1}'),
                ),
                DataCell(
                  Text(
                    p.productName,
                    style: index == 0 ? const TextStyle(fontWeight: FontWeight.w600) : null,
                  ),
                ),
                DataCell(Text(p.totalQuantity.toString())),
                DataCell(Text(currency.format(p.totalRevenue))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
