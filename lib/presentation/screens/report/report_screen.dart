import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/report/report_notifier.dart';
import '../../providers/report/report_state.dart';
import 'components/daily_report_table.dart';
import 'components/monthly_report_table.dart';
import 'components/top_products_table.dart';
import 'components/payment_summary_table.dart';
import 'components/report_date_filter.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportNotifierProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportNotifierProvider);
    final notifier = ref.read(reportNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _TabBar(activeTab: state.activeTab, onTabChanged: notifier.setTab),
          if (state.activeTab != ReportTab.monthly)
            ReportDateFilter(
              startDate: state.startDate,
              endDate: state.endDate,
              onDateRangeChanged: notifier.setDateRange,
            )
          else
            _YearSelector(
              selectedYear: state.selectedYear,
              onYearChanged: notifier.setYear,
            ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null
                    ? _ErrorView(message: state.errorMessage!)
                    : _TabContent(state: state),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final ReportTab activeTab;
  final void Function(ReportTab) onTabChanged;

  const _TabBar({required this.activeTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (ReportTab.daily, 'Harian'),
      (ReportTab.monthly, 'Bulanan'),
      (ReportTab.topProducts, 'Produk Terlaris'),
      (ReportTab.payment, 'Pembayaran'),
    ];

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: tabs.map((tab) {
            final isActive = activeTab == tab.$1;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(tab.$2),
                selected: isActive,
                onSelected: (_) => onTabChanged(tab.$1),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  final int selectedYear;
  final void Function(int) onYearChanged;

  const _YearSelector({required this.selectedYear, required this.onYearChanged});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - i);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Tahun:'),
          const SizedBox(width: 12),
          DropdownButton<int>(
            value: selectedYear,
            items: years
                .map(
                  (y) => DropdownMenuItem(
                    value: y,
                    child: Text(y.toString()),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onYearChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final ReportState state;

  const _TabContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.activeTab) {
      ReportTab.daily => DailyReportTable(reports: state.dailyReports),
      ReportTab.monthly => MonthlyReportTable(reports: state.monthlyReports),
      ReportTab.topProducts => TopProductsTable(products: state.topProducts),
      ReportTab.payment => PaymentSummaryTable(summary: state.paymentSummary),
    };
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Terjadi kesalahan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
