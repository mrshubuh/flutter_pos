import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/di/app_providers.dart';
import 'package:intl/intl.dart';

import '../../../core/common/result.dart';
import '../../../data/datasources/local/report_local_datasource_impl.dart';
import '../../../data/datasources/repositories/report_repository_impl.dart';
import '../../../domain/usecases/report_usecases.dart';
import '../../providers/report/report_state.dart';

final reportNotifierProvider = NotifierProvider<ReportNotifier, ReportState>(ReportNotifier.new);

class ReportNotifier extends Notifier<ReportState> {
  late final GetDailyReportUsecase _getDailyReport;
  late final GetMonthlyReportUsecase _getMonthlyReport;
  late final GetTopProductsUsecase _getTopProducts;
  late final GetPaymentSummaryUsecase _getPaymentSummary;

  @override
  ReportState build() {
    final datasource = ReportLocalDatasourceImpl(ref.read(appDatabaseProvider));
    final repository = ReportRepositoryImpl(datasource);

    _getDailyReport = GetDailyReportUsecase(repository);
    _getMonthlyReport = GetMonthlyReportUsecase(repository);
    _getTopProducts = GetTopProductsUsecase(repository);
    _getPaymentSummary = GetPaymentSummaryUsecase(repository);

    return ReportState.initial();
  }

  void setTab(ReportTab tab) {
    state = state.copyWith(activeTab: tab, errorMessage: null);
    _loadCurrentTab();
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end, errorMessage: null);
    _loadCurrentTab();
  }

  void setYear(int year) {
    state = state.copyWith(selectedYear: year, errorMessage: null);
    if (state.activeTab == ReportTab.monthly) _loadMonthlyReport();
  }

  void _loadCurrentTab() {
    switch (state.activeTab) {
      case ReportTab.daily:
        _loadDailyReport();
        break;
      case ReportTab.monthly:
        _loadMonthlyReport();
        break;
      case ReportTab.topProducts:
        _loadTopProducts();
        break;
      case ReportTab.payment:
        _loadPaymentSummary();
        break;
    }
  }

  Future<void> loadAll() async {
    await Future.wait([
      _loadDailyReport(),
      _loadMonthlyReport(),
      _loadTopProducts(),
      _loadPaymentSummary(),
    ]);
  }

  Future<void> _loadDailyReport() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final startStr = DateFormat('yyyy-MM-dd').format(state.startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(state.endDate);
    final result = await _getDailyReport(startDate: startStr, endDate: endStr);

    switch (result) {
      case Success():
        state = state.copyWith(dailyReports: result.data, isLoading: false);
      case Failure():
        state = state.copyWith(isLoading: false, errorMessage: result.error.toString());
    }
  }

  Future<void> _loadMonthlyReport() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _getMonthlyReport(year: state.selectedYear);

    switch (result) {
      case Success():
        state = state.copyWith(monthlyReports: result.data, isLoading: false);
      case Failure():
        state = state.copyWith(isLoading: false, errorMessage: result.error.toString());
    }
  }

  Future<void> _loadTopProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final startStr = DateFormat('yyyy-MM-dd').format(state.startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(state.endDate);
    final result = await _getTopProducts(startDate: startStr, endDate: endStr, limit: 10);

    switch (result) {
      case Success():
        state = state.copyWith(topProducts: result.data, isLoading: false);
      case Failure():
        state = state.copyWith(isLoading: false, errorMessage: result.error.toString());
    }
  }

  Future<void> _loadPaymentSummary() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final startStr = DateFormat('yyyy-MM-dd').format(state.startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(state.endDate);
    final result = await _getPaymentSummary(startDate: startStr, endDate: endStr);

    switch (result) {
      case Success():
        state = state.copyWith(paymentSummary: result.data, isLoading: false);
      case Failure():
        state = state.copyWith(isLoading: false, errorMessage: result.error.toString());
    }
  }
}
